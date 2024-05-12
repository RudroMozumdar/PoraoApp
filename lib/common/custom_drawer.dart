import 'package:porao_app/common/all_import.dart';
// https://youtu.be/ufer4QTFTO8

class CustomDrawer extends StatefulWidget {
  final String username;
  const CustomDrawer({super.key, required this.username});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
          Navigator.of(context).push(
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
    return Column(
      children: [
        menuItem(1, "Personal Details", Icons.person, true,
            MaterialPageRoute(builder: (BuildContext context) {
          return const PersonalDetails();
        })),
        menuItem(2, "Settings", Icons.settings, false,
            MaterialPageRoute(builder: (BuildContext context) {
          return const AppSettings();
        })),
        menuItem(3, "Feedback", Icons.feedback, false,
            MaterialPageRoute(builder: (BuildContext context) {
          return const FeedBack();
        })),
        menuItem(4, "FAQ", Icons.format_quote, false,
            MaterialPageRoute(builder: (BuildContext context) {
          return const Faq();
        })),
        menuItem(5, "Connect Us", Icons.waving_hand, false,
            MaterialPageRoute(builder: (BuildContext context) {
          return const PublicProfile();
        })),
        menuItem(6, "Log Out", Icons.logout_rounded, false,
            MaterialPageRoute(builder: (BuildContext context) {
          return const PublicProfile();
        })),
      ],
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected,
      MaterialPageRoute targetPage) {
    return Material(
      color: selected
          ? const Color.fromARGB(255, 218, 218, 218)
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(targetPage);
        },
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
