import 'package:porao_app/common/all_import.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Text(
              user?.email ?? 'User Email',
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            ElevatedButton(
              onPressed: () {
                Auth().signOut();
              },
              child: const Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
