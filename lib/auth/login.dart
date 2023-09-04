import 'package:porao_app/common/all_import.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errorMessage = '';
  bool passwordShowHide = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  // Login-----------------------------------------------------------------------
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

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/images/backgrounds/login_page_background_image.png'),
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
              child: Text(
                "Porate Chai",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: primaryFont,
                ),
              ),
            ),
            const Spacer(),

            // Get started Text-------------------------------------------------
            Visibility(
              visible: !isKeyboardOpen,
              child: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Hi There!!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: primaryFont,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !isKeyboardOpen,
              child: Container(
                padding: const EdgeInsets.only(bottom: 15),
                alignment: Alignment.topCenter,
                child: Text(
                  "Let's Get Started!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    fontFamily: primaryFont,
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
                    CustomTextField(
                      hintText: "E-mail",
                      prefixIcon: const Icon(Icons.alternate_email),
                      borderRadius: 40,
                      controller: _controllerEmail,
                      textInpputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Password Field ------------------------------------------
                    CustomTextField(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.key),
                      sufffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordShowHide = !passwordShowHide;
                          });
                        },
                        icon: Icon(passwordShowHide
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                      borderRadius: 40,
                      controller: _controllerPassword,
                      textInpputType: TextInputType.visiblePassword,
                      showHideText: !passwordShowHide,
                    ),
                    const SizedBox(height: 20),

                    // Login button---------------------------------------------
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shadowColor: const Color.fromARGB(255, 78, 78, 78),
                        backgroundColor: const Color(0xFF77258B),
                        minimumSize: const Size(double.infinity, 63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        signInWithEmailAndPassword();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: primaryFont,
                            ),
                          ),
                          const Icon(
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
                        elevation: 5,
                        shadowColor: const Color.fromARGB(255, 61, 61, 61),
                        minimumSize: const Size(double.infinity, 63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF77258B),
                          fontFamily: primaryFont,
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
