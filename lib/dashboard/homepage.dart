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
          createPostSection(context),
          feedText(),
          questions(context),
        ],
      ),
    );
  }
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

Widget createPostSection(BuildContext context) {
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

Widget feedText() {
  return Container(
    padding: const EdgeInsets.only(top: 20, left: 10),
    width: double.infinity,
    child: Text(
      "Your daily question feed",
      style: TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
      ),
    ),
  );
}

Widget questions(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('posts').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(),
          ),
        );
      }

      final posts = snapshot.data!.docs;

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          DocumentSnapshot post = posts[index];
          final timestamp = post['createdAt'] as Timestamp;
          var vote = 0;

          // Check if user has already voted
          if (post['upvotes'].contains(Auth().currentUser?.uid)) {
            vote = 1;
          } else if (post['downvotes']
              .contains(FirebaseAuth.instance.currentUser?.uid)) {
            vote = -1;
          }

          // final answerController = TextEditingController();
          DocumentReference docRef =
              FirebaseFirestore.instance.collection('posts').doc(post.id);

          Reference referanceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirDP = referanceRoot.child('display-pictures');

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: seconderyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      children: [
                        // Image
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(post['dp-url']),
                        ),

                        // Name
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: Text(
                                  post['authorName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: primaryFont,
                                  ),
                                ),
                                onTap: () {
                                  // Takes to the profile of the post author
                                },
                              ),
                              Text(
                                formatTimeDifference(DateTime.now()
                                    .difference(timestamp.toDate())),
                                style: TextStyle(fontFamily: primaryFont),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      post['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: primaryFont,
                      ),
                    ),
                    subtitle: Text(
                      post['content'],
                      style: TextStyle(
                        fontFamily: primaryFont,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: vote == 1 ? primaryColor : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (vote == 0) {
                              docRef.update({
                                'upvotes': FieldValue.arrayUnion(
                                    [Auth().currentUser?.uid])
                              });
                            } else if (vote == -1) {
                              docRef.update({
                                'downvotes': FieldValue.arrayRemove(
                                    [Auth().currentUser?.uid])
                              });
                              docRef.update({
                                'upvotes': FieldValue.arrayUnion(
                                    [Auth().currentUser?.uid])
                              });
                            } else {
                              docRef.update({
                                'upvotes': FieldValue.arrayRemove(
                                    [Auth().currentUser?.uid])
                              });
                            }
                          },
                          icon: const Icon(Icons.arrow_upward_rounded),
                          tooltip: 'Upvote',
                          color: vote == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                      Text((post['upvotes'].length - post['downvotes'].length)
                          .toString()),
                      // -----------------------------------------------------------------Downvote Button
                      Container(
                        decoration: BoxDecoration(
                          color: vote == -1 ? primaryColor : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (vote == 0) {
                              docRef.update({
                                'downvotes': FieldValue.arrayUnion(
                                    [Auth().currentUser?.uid])
                              });
                            } else if (vote == 1) {
                              docRef.update({
                                'upvotes': FieldValue.arrayRemove(
                                    [Auth().currentUser?.uid])
                              });
                              docRef.update({
                                'downvotes': FieldValue.arrayUnion(
                                    [Auth().currentUser?.uid])
                              });
                            } else {
                              docRef.update({
                                'downvotes': FieldValue.arrayRemove(
                                    [Auth().currentUser?.uid])
                              });
                            }
                          },
                          icon: const Icon(Icons.arrow_downward_rounded),
                          tooltip: 'Downvote',
                          color: vote == -1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Get the question data (replace with your actual way of accessing data)
                          final String title = post['title'];
                          final String content = post['content'];

                          // Navigate to the AnswerPage with data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnswerPage(
                                  questionTitle: title,
                                  questionContent: content),
                            ),
                          );
                        },
                        icon: const Icon(Icons.comment),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
