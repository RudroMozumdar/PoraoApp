import 'package:porao_app/common/all_import.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          post("Rudro Mozumdar", "assets/images/rudro.jpg"),
          post("Jannatul Ferdous Sithi", "assets/images/jannat.jpg"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
          post("Masud Hassan", "assets/images/masud.png"),
        ],
      ),
    );
  }

  Widget post(String name, String image) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 2,
          color: const Color.fromARGB(255, 230, 230, 230),
        ),
      ),
      child: Column(
        children: [
          // Details -------------------------------------------------------
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(image),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: primaryFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Computer Science & Engineering",
                      style: TextStyle(
                        fontFamily: primaryFont,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "11 Hours Ago",
                      style: TextStyle(
                        fontFamily: primaryFont,
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Main Post -----------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              style: TextStyle(
                fontFamily: primaryFont,
                fontSize: 13,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          // Reacts --------------------------------------------------------
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
                child: Icon(
                  Icons.favorite,
                  color: Colors.red[400],
                  size: 19,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  "150 People",
                  style: TextStyle(
                    fontFamily: primaryFont,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Divider(indent: 10, endIndent: 10),
          // Actions ------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite),
                label: Text(
                  "Like",
                  style: TextStyle(
                      fontFamily: primaryFont,
                      fontSize: 14,
                      color: const Color.fromARGB(255, 131, 131, 131)),
                ),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  elevation: MaterialStatePropertyAll(0),
                  iconColor: MaterialStatePropertyAll(Colors.red),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.comment),
                label: Text(
                  "Comment",
                  style: TextStyle(
                      fontFamily: primaryFont,
                      fontSize: 14,
                      color: const Color.fromARGB(255, 131, 131, 131)),
                ),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  elevation: MaterialStatePropertyAll(0),
                  iconColor: MaterialStatePropertyAll(Colors.grey),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: Text(
                  "Share",
                  style: TextStyle(
                      fontFamily: primaryFont,
                      fontSize: 14,
                      color: const Color.fromARGB(255, 131, 131, 131)),
                ),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  elevation: MaterialStatePropertyAll(0),
                  iconColor: MaterialStatePropertyAll(Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
