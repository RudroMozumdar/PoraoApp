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
                // Show Pulic Profile-----------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 200,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: primaryButtonColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Show Public Profile",
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontFamily: primaryFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(endIndent: 30, indent: 30),
                options("Personal Details", Icons.person),
                options("Settings", Icons.settings),
                options("Feedack", Icons.format_quote),
                options("FAQ", Icons.feedback),
                options("Log Out", Icons.logout),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget options(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(
        onTap: () {
          Auth().signOut();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
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
