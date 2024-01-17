import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartgarden/components/button.dart';
import 'package:smartgarden/components/text_field.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text field controller
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  // signin method
  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailTextController.text.trim(),
      password: _passwordTextController.text.trim(),
    );
    print("button clicked");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/background3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  // Sign-in Content
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          // login
                          Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xFF207D4A),
                            ),
                          ),
                          // welcome message
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            "Welcome back, you've been missed!",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          // email textfield
                          MyTextField(
                            controller: _emailTextController,
                            hintText: "Email",
                            obscureText: false,
                            icon: Icon(Icons.mail),
                          ),

                          // password textfield
                          const SizedBox(
                            height: 15,
                          ),
                          MyTextField(
                            controller: _passwordTextController,
                            hintText: "Password",
                            obscureText: true,
                            icon: Icon(Icons.lock),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Forgot ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ForgotPasswordPage();
                                    }));
                                  },
                                  child: Text(
                                    "Password?",
                                    style: TextStyle(
                                        color: Color(0xFF207D4A),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // signin button
                          MyButton(onTap: signIn, text: "SignIn"),

                          // go to register page
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Not a member?",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: const Text(
                                  "Register Now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF207D4A),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
