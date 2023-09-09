import 'package:porao_app/common/all_import.dart';

class StudentInformation extends StatefulWidget {
  const StudentInformation({super.key});

  @override
  State<StudentInformation> createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
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
        appBar: const CustomAppBar(title: "Student Information"),
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Container(
                width: 340,
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(30)),
                      child: Image.asset(
                        "assets/images/masud_high_quality.png",
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: Masud Hasan",
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            "Education: NSU",
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            "Class: 8",
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            "Subject: Bangla, English",
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            "Location: Rampura",
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.cancel_rounded,
                        size: 70,
                        color: Colors.orange,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.check_circle_rounded,
                        size: 70,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
