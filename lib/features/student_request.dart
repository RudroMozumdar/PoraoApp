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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: "Student Requests"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(101, 153, 153, 153),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/images/masud.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Masud Hasan",
                              style: TextStyle(fontFamily: primaryFont),
                            ),
                            Text(
                              "Class: 8",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Location: Aftabnagar, Dhaka",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Subject: English, Physics",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Redundent / For now----------------------------------------------------
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/images/masud.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Masud Hasan",
                              style: TextStyle(fontFamily: primaryFont),
                            ),
                            Text(
                              "Class: 8",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Location: Aftabnagar, Dhaka",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Subject: English, Physics",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/images/masud.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Masud Hasan",
                              style: TextStyle(fontFamily: primaryFont),
                            ),
                            Text(
                              "Class: 8",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Location: Aftabnagar, Dhaka",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Subject: English, Physics",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/images/masud.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Masud Hasan",
                              style: TextStyle(fontFamily: primaryFont),
                            ),
                            Text(
                              "Class: 8",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Location: Aftabnagar, Dhaka",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Subject: English, Physics",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/images/masud.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Masud Hasan",
                              style: TextStyle(fontFamily: primaryFont),
                            ),
                            Text(
                              "Class: 8",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Location: Aftabnagar, Dhaka",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Subject: English, Physics",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/images/masud.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Masud Hasan",
                              style: TextStyle(fontFamily: primaryFont),
                            ),
                            Text(
                              "Class: 8",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Location: Aftabnagar, Dhaka",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Subject: English, Physics",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/images/masud.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Masud Hasan",
                              style: TextStyle(fontFamily: primaryFont),
                            ),
                            Text(
                              "Class: 8",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Location: Aftabnagar, Dhaka",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Subject: English, Physics",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Redundent / For now ends----------------------------------------------------
              ],
            ),
          ),
        ),
      ),
    );
  }
}
