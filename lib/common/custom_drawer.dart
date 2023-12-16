import 'package:porao_app/common/all_import.dart';
// https://youtu.be/ufer4QTFTO8

class CustomDrawer extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  const CustomDrawer({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            drawerHeader(context),
            drawerList(),
          ],
        ),
      ),
    );
  }

  Widget drawerHeader(BuildContext context) {
    return Container(
      color: primaryColor,
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Profile(),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(
                  "assets/images/masud_high_quality.png",
                )),
              ),
            ),
            const Text(
              "Masud Hasan",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              Auth().currentUser?.email ?? 'User Email',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerList() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, "Dashboard", Icons.dashboard, true),
          menuItem(1, "Contacts", Icons.contact_page, false),
          menuItem(1, "Notes", Icons.note, false),
          menuItem(1, "Notifications", Icons.notifications, false),
          menuItem(1, "Feedback", Icons.feedback, false),
          menuItem(1, "Privacy Policy", Icons.privacy_tip, false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected
          ? const Color.fromARGB(255, 218, 218, 218)
          : Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

enum DrawerSectons {
  dashboard,
  contacts,
  events,
  notes,
  settings,
  notifications,
  privacypolicy,
  fedback,
}
