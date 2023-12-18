import 'package:porao_app/common/all_import.dart';

class StudentRequests extends StatefulWidget {
  const StudentRequests({super.key});

  @override
  State<StudentRequests> createState() => _StudentRequestsState();
}

class _StudentRequestsState extends State<StudentRequests> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 255, 184, 0), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Scaffold(),
    );
  }
}
