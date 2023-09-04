import 'package:porao_app/common/all_import.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: const Color.fromARGB(169, 229, 243, 36),
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Text(
              user?.email ?? 'User Email',
              style: const TextStyle(fontSize: 20),
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
