import 'package:porao_app/common/all_import.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> selectedList = [false, false, false];
  List<int> voteCounter = [0, 0, 0];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          header("Rudro Mozumdar", "assets/images/rudro.jpg"),
          createPostSection(),
          Container(
            padding: const EdgeInsets.only(top: 20, left: 10),
            width: double.infinity,
            child: Text(
              "Your daily question feed",
              style: TextStyle(
                fontFamily: primaryFont,
                fontSize: 20,
              ),
            ),
          ),
          // post("Rudro Mozumdar", "assets/images/rudro.jpg", 0),
          // post("Jannatul Ferdous Sithi", "assets/images/jannat.jpg", 1),
          // post("Masud Hassan", "assets/images/masud.png", 2),
        ],
      ),
    );
  }

  Widget header(String name, String image) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          height: 75,
          width: 75,
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
                "Welcome",
                style: TextStyle(
                  fontFamily: primaryFont,
                  fontSize: 16,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontFamily: primaryFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "24Y, Computer Science & Engineering",
                style: TextStyle(
                  fontFamily: primaryFont,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget createPostSection() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(builder: (context) {
          return const CreatePost();
        }));
      },
      child: Hero(
        tag: 'createPost',
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                style: BorderStyle.solid,
                width: 2,
                color: const Color.fromARGB(255, 230, 230, 230),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  "Have something on your mind?",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: primaryFont,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.add_rounded,
                    size: 60,
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget post(String name, String image, int index) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
                      "23Y, Computer Science & Engineering",
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
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedList[index] = !selectedList[index];
                  });
                },
                icon: Icon(
                  selectedList[index]
                      ? Icons.arrow_drop_down_rounded
                      : Icons.arrow_drop_up_rounded,
                ),
              ),
            ],
          ),
          // Main Post -----------------------------------------------------
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastEaseInToSlowEaseOut,
            height: selectedList[index] ? 180 : 65,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Expanded(
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                style: TextStyle(
                  fontFamily: primaryFont,
                  fontSize: 13,
                ),
                textAlign: TextAlign.justify,
                maxLines: selectedList[index] ? 100 : 3,
                overflow: TextOverflow.ellipsis,
              ),
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
              IconButton(
                onPressed: () {
                  setState(() {
                    voteCounter[index]++;
                  });
                },
                icon: const Icon(Icons.keyboard_double_arrow_up_sharp),
              ),
              Text(voteCounter[index].toString()),
              IconButton(
                onPressed: () {
                  setState(() {
                    voteCounter[index]--;
                  });
                },
                icon: const Icon(Icons.keyboard_double_arrow_down_sharp),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.recommend),
                label: Text(
                  "Recomend",
                  style: TextStyle(
                      fontFamily: primaryFont,
                      fontSize: 12,
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
                icon: const Icon(Icons.question_answer),
                label: Text(
                  "Answer",
                  style: TextStyle(
                      fontFamily: primaryFont,
                      fontSize: 12,
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
