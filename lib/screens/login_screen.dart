import 'package:flutter/material.dart';

class login_Screen extends StatelessWidget {
  const login_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 20,
              ),
              Image(
                image: const NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo9dqwwDcgvlxyYsZBLNKJf3zih52MW0VcVQ&usqp=CAU"),
                height: size.height * 0.2,
              ),
              const Text(
                "Welcome Back,",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const Text(
                "Let's Get In With Your Account's Credentia.",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              Form(
                  child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: "E-Mail",
                          hintText: "E-Mail",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.fingerprint),
                          labelText: "Password",
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye_outlined),
                            onPressed: null,
                          ),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password"),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("- OR -"),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: OutlinedButton.icon(
                            icon: const Image(
                              image: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtdUuKocOzOeu92a6nxPTGEPci8ZuQsfz3Mg&usqp=CAU"),
                              width: 30.0,
                            ),
                            label: const Text("Sign In With Google"),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text.rich(
                            TextSpan(
                              text: "Don't have an Account?",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: " Sign Up",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))
            ]),
          ),
        ),
      ),
    );
  }
}
