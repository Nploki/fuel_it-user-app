import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fuel_it/screens/profile_update.dart';
import 'package:fuel_it/screens/welcome_screen.dart';
import 'package:fuel_it/services/user_services.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String id = "Profile";

  @override
  Widget build(BuildContext context) {
    UserServices _services = UserServices();
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_services.userId())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.green,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
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
                              child: userData['gender'] == 'female'
                                  ? const Image(
                                      image: NetworkImage(
                                          "https://qph.cf2.quoracdn.net/main-qimg-cdc1f07de94373a3476b1aab87ebcefc-pjlq"))
                                  : const Image(
                                      image: NetworkImage(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfWwvGQn3hznks_Xjm7qv27_cZ_rOcEOfsVQ&usqp=CAU")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 160,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.person_alt_circle,
                                  size: 35,
                                  color: Colors.blue,
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  userData['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.phone_circle,
                                  size: 35,
                                  color: Colors.green,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  userData['number'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 35,
                                child: ElevatedButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut().then(
                                      (value) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                welcome_screen(),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide.none,
                                      shape: const StadiumBorder(),
                                      backgroundColor: const Color.fromARGB(
                                          255, 206, 54, 97)),
                                  child: const Text(
                                    'Log - Out',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.fingerprint,
                            color: Colors.orange,
                            size: 35,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Aadhar Number",
                            style: GoogleFonts.chakraPetch(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.065,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(12.5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text("Number"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(" : "),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userData['aadhar'],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.directions_bike_sharp,
                            color: Colors.red,
                            size: 35,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Bike Details",
                            style: GoogleFonts.chakraPetch(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.11,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text("Lisence No"),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(" : "),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(userData['lisence'])
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Bike No"),
                                    const SizedBox(
                                      width: 32.5,
                                    ),
                                    const Text(" : "),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(userData['bike_no'])
                                  ],
                                )
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            CupertinoIcons.home,
                            color: Colors.blue,
                            size: 35,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Address",
                            style: GoogleFonts.chakraPetch(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 75,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        // alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 10, 5),
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              userData['address'],
                              maxLines: 2,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileUpdate(
                                      name: userData['name'],
                                      phno: userData['number'],
                                      aadhar: userData['aadhar'],
                                      bikeno: userData['bike_no'],
                                      lisence: userData['lisence'],
                                      address: userData['address'],
                                      uid: userData['id'],
                                      gender: userData['gender'])),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.green),
                          child: const Text(
                            'Edit Profile',
                            // 'Log - Out',
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
        );
      },
    );
  }
}
