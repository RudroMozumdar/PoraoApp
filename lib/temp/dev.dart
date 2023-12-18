import 'package:porao_app/common/all_import.dart';

class Devolopment extends StatefulWidget {
  const Devolopment({super.key});

  @override
  State<Devolopment> createState() => _DevolopmentState();
}

class _DevolopmentState extends State<Devolopment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
          child: const Text("Login"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUp(),
              ),
            );
          },
          child: const Text("Signup"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UpdateInformation(),
              ),
            );
          },
          child: const Text("Update Information"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
            );
          },
          child: const Text("Dashboard"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          child: const Text("Homepage"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentRequests(),
              ),
            );
          },
          child: const Text("Student Request"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentInformation(),
              ),
            );
          },
          child: const Text("Student Information"),
        ),
      ],
    );
  }
}
