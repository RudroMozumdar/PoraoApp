import '../common/all_import.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? errorMessage = '';
  bool _passwordShowHide = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUserame = TextEditingController();
  final TextEditingController _controllerDOB = TextEditingController();
  final TextEditingController _controllerInstitution = TextEditingController();
  final TextEditingController _controllerNID = TextEditingController();

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

  //Username Field -------------------------------------------------------------
  Widget _usernameField() {
    return CustomTextField(
      hintText: "Username",
      prefixIcon: const Icon(Icons.person_outline),
      borderRadius: 40,
      controller: _controllerUserame,
    );
  }

  //Email Field -------------------------------------------------------------
  Widget _emailField() {
    return CustomTextField(
      hintText: "E-mail",
      prefixIcon: const Icon(Icons.alternate_email),
      borderRadius: 40,
      controller: _controllerEmail,
    );
  }

  //Password Field -------------------------------------------------------------
  Widget _passwordField() {
    return CustomTextField(
      hintText: "Create Password",
      prefixIcon: const Icon(Icons.lock_outline),
      borderRadius: 40,
      controller: _controllerPassword,
      sufffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _passwordShowHide = !_passwordShowHide;
          });
        },
        icon: Icon(_passwordShowHide
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined),
      ),
      showHideText: !_passwordShowHide,
    );
  }

  //Date of birth Field -------------------------------------------------------------
  Widget _dobField() {
    return CustomTextField(
      hintText: "Date of Birth",
      prefixIcon: const Icon(Icons.calendar_today_outlined),
      borderRadius: 40,
      controller: _controllerDOB,
    );
  }

  //Institution Field -------------------------------------------------------------
  Widget _institutionField() {
    return CustomTextField(
      hintText: "Institution Name",
      prefixIcon: const Icon(Icons.home_outlined),
      borderRadius: 40,
      controller: _controllerInstitution,
    );
  }

  //NID Field -------------------------------------------------------------
  Widget _nidField() {
    return CustomTextField(
      hintText: "National ID Card Number",
      prefixIcon: const Icon(Icons.verified_user_outlined),
      borderRadius: 40,
      controller: _controllerNID,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 178, 134, 255), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text(
              "Create a new account",
              style: TextStyle(
                fontFamily: primaryFont,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(children: [
              _usernameField(),
              const SizedBox(height: 15),
              _emailField(),
              const SizedBox(height: 15),
              _passwordField(),
              const SizedBox(height: 15),
              _dobField(),
              const SizedBox(height: 15),
              _institutionField(),
              const SizedBox(height: 15),
              _nidField(),
              const SizedBox(height: 15),
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
                  createUserWithEmailAndPassword();
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
            ]),
          ),
        ),
      ),
    );
  }
}
