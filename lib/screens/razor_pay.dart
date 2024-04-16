import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class razorPayPage extends StatefulWidget {
  final String productId;
  final String amount;
  const razorPayPage({Key? key, required this.productId, required this.amount})
      : super(key: key);

  @override
  State<razorPayPage> createState() => _razorPayPageState();
}

class _razorPayPageState extends State<razorPayPage> {
  late Razorpay _razorpay;
  TextEditingController amountController = TextEditingController();

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount,
      'name': 'Payment',
      'prefill': {'contact': '123567890', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successfull${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);

    FirebaseFirestore.instance
        .collection('order')
        .doc(widget.productId)
        .update({
      'paymentId': response.paymentId!,
      'payment': true,
    }).then((value) {
      print('Payment marked as successful in the database');
    }).catchError((error) {
      print('Failed to mark payment as successful: $error');
    });
  }

  void handlePaymentError(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Failure ...");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.amount);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Image.network(
              'https://www.pngall.com/wp-content/uploads/5/Online-Payment-PNG-Image.png',
              height: 100,
              width: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "RazorPay Payment \nGateWay",
              style: GoogleFonts.chakraPetch(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                // style: const TextStyle(color: Colors.white),
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Enter Amount',
                  labelStyle: TextStyle(
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  if (amountController.text.toString().isNotEmpty) {
                    setState(() {
                      int amount = int.parse(amountController.text.toString());
                      openCheckout(amount);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Pay',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
