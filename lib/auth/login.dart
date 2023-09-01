import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errorMessage = 'Hi';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  // Logi-----------------------------------------------------------------------
  Future<void> signInWithEmailAndPassword() async {
    try {
      // Sign in Attampt
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  // Sign Up--------------------------------------------------------------------
  Future<void> createUserWithEmailAndPassword() async {
    try {
      // Sign in Attampt
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/backgrounds/login_page_background_image.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // Body Starts Here-----------------------------------------------------
        body: Column(
          children: [
            // Porate Chai Logo-------------------------------------------------
            Container(
              padding: EdgeInsets.only(top: isKeyboardOpen ? 40 : 100),
              alignment: Alignment.topCenter,
              child: const Text(
                "Porate Chai",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),

            // Get started Text-------------------------------------------------
            Visibility(
              visible: !isKeyboardOpen,
              child: Container(
                alignment: Alignment.topCenter,
                child: const Text(
                  "Hi There",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !isKeyboardOpen,
              child: Container(
                padding: const EdgeInsets.only(bottom: 15),
                alignment: Alignment.topCenter,
                child: const Text(
                  "Let's Get Started!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // White  Gradient rounded  box ------------------------------------
            Container(
              height: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Colors.white, Color.fromARGB(255, 66, 66, 54)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 50),

                    // Email Field ---------------------------------------------
                    TextField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.alternate_email),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field ------------------------------------------
                    TextField(
                      controller: _controllerPassword,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login button---------------------------------------------
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF77258B),
                        minimumSize: const Size(double.infinity, 63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        signInWithEmailAndPassword();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Or-------------------------------------------------------
                    const Stack(
                      children: [
                        Divider(
                          color: Colors.white,
                          indent: 170,
                          height: 25,
                        ),
                        Center(
                            child: Text(
                          "Or",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                        Divider(
                          color: Colors.white,
                          endIndent: 170,
                          height: 25,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Signup/ Create An account button ------------------------
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        createUserWithEmailAndPassword();
                      },
                      child: const Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF77258B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
