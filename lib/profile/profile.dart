import 'package:porao_app/common/all_import.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.elliptical(80, 30),
                  bottomRight: Radius.elliptical(80, 30),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 125),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 125,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/masud_high_quality.png",
                      ),
                    ),
                  ),
                ),
                Text(
                  "Masud Hasan",
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontFamily: primaryFont,
                  ),
                ),
                Text(
                  Auth().currentUser?.email ?? 'User Email',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontFamily: primaryFont,
                  ),
                ),
                const Divider(endIndent: 30, indent: 30),
                options(
                    "Personal Details", Icons.person, const PersonalDetails()),
                options("Settings", Icons.settings, const AppSettings()),
                options("Feedack", Icons.format_quote, const FeedBack()),
                options("FAQ", Icons.feedback, const Faq()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InkWell(
                    onTap: () {
                      Auth().signOut();
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const Login();
                          },
                        ),
                        (_) => false,
                      );
                    },
                    child: Container(
                      width: 320,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(0, 0, 0, 0)),
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(width: 5),
                          Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontFamily: primaryFont,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget options(String title, IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return page;
          }));
        },
        child: Container(
          width: 320,
          decoration: const BoxDecoration(color: Color.fromARGB(0, 0, 0, 0)),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontFamily: primaryFont,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
