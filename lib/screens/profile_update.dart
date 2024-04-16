import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class ProfileUpdate extends StatefulWidget {
  final String name;
  final String phno;
  final String aadhar;
  final String bikeno;
  final String lisence;
  final String address;
  final String uid;
  final String gender;

  ProfileUpdate({
    required this.name,
    required this.phno,
    required this.aadhar,
    required this.bikeno,
    required this.lisence,
    required this.address,
    required this.uid,
    required this.gender,
  });

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  late TextEditingController nameController;
  late TextEditingController phnoController;
  late TextEditingController aadharController;
  late TextEditingController bikeNoController;
  late TextEditingController lisenceController;
  late TextEditingController addressController;
  late PageController _pageController;
  bool isMale = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phnoController = TextEditingController(text: widget.phno);
    aadharController = TextEditingController(text: widget.aadhar);
    bikeNoController = TextEditingController(text: widget.bikeno);
    lisenceController = TextEditingController(text: widget.lisence);
    addressController = TextEditingController(text: widget.address);
    _pageController = PageController(initialPage: isMale ? 0 : 1);
    isMale = widget.gender == "male" ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                                image: NetworkImage(isMale
                                    ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfWwvGQn3hznks_Xjm7qv27_cZ_rOcEOfsVQ&usqp=CAU"
                                    : "https://qph.cf2.quoracdn.net/main-qimg-cdc1f07de94373a3476b1aab87ebcefc-pjlq")),
                          ),
                        ),
                        Positioned(
                          bottom: 0.5,
                          right: 0.5,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color.fromARGB(255, 255, 251, 12),
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  const Text(
                                                    'Gender  :  ',
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                  LiteRollingSwitch(
                                                    value: !isMale,
                                                    onTap: () {
                                                      setState(() {
                                                        isMale = !isMale;
                                                      });
                                                    },
                                                    onDoubleTap: () {
                                                      setState(() {
                                                        isMale = !isMale;
                                                      });
                                                    },
                                                    onSwipe: () {
                                                      setState(() {
                                                        isMale = !isMale;
                                                      });
                                                    },
                                                    iconOn: Icons.female,
                                                    iconOff: Icons.male,
                                                    colorOn: Colors.pink,
                                                    colorOff: Colors.blue,
                                                    textOffColor: Colors.white,
                                                    textOnColor: Colors.white,
                                                    textSize: 17.5,
                                                    onChanged: (bool state) {
                                                      if (state) {
                                                        isMale = true;
                                                      } else {
                                                        isMale = false;
                                                      }
                                                    },
                                                    animationDuration:
                                                        const Duration(
                                                            milliseconds: 500),
                                                    textOn: "Female",
                                                    textOff: "Male",
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                alignment: Alignment.center,
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 0, 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.53,
                      height: 150,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_outlined,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  labelText: "User Name",
                                  hintText: "User Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 250,
                            height: 65,
                            child: TextFormField(
                              controller: phnoController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  labelText: "Phone No",
                                  hintText: "Phone No",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: aadharController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.fingerprint,
                          color: Colors.orange,
                          size: 30,
                        ),
                        labelText: "Aadhar Number",
                        hintText: "Aadhar Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: bikeNoController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.electric_bike_rounded,
                          color: Colors.red,
                          size: 30,
                        ),
                        labelText: "Bike Number",
                        hintText: "Bike Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: lisenceController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.document_scanner,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                        labelText: "Lisence Number",
                        hintText: "Lisence Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          CupertinoIcons.home,
                          color: Colors.lightBlue,
                          size: 30,
                        ),
                        labelText: "Address",
                        hintText: "Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.uid)
                              .update({
                            'name': nameController.text,
                            'number': phnoController.text,
                            'aadhar': aadharController.text,
                            'bike_no': bikeNoController.text,
                            'lisence': lisenceController.text,
                            'address': addressController.text,
                            'gender': isMale ? "male" : "female",
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.green),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phnoController.dispose();
    aadharController.dispose();
    bikeNoController.dispose();
    lisenceController.dispose();
    addressController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
