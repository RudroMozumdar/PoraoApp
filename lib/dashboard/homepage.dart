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
          // questions(),
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

  Widget questions() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: SizedBox(
              width: 50.0, // Adjust the width as needed
              height: 50.0, // Adjust the height as needed
              child: CircularProgressIndicator(),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot post = snapshot.data!.docs[index];
            final timestamp = post['createdAt'] as Timestamp;
            var vote = 0;

            // Check if voted already or not--------------------------------------------
            if (post['upvotes'].contains(Auth().currentUser?.uid)) {
              vote = 1;
            } else if (post['downvotes']
                .contains(FirebaseAuth.instance.currentUser?.uid)) {
              vote = -1;
            }

            DocumentReference docRef =
                FirebaseFirestore.instance.collection('posts').doc(post.id);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: seconderyColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(post['title']),
                      subtitle: Text(post['content']),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(formatTimeDifference(
                          DateTime.now().difference(timestamp.toDate()))),
                    ),
                    // ------------------------------------------------------------------Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ---------------------------------------------------------------Upvote button
                        Container(
                          decoration: BoxDecoration(
                            color:
                                vote == 1 ? primaryColor : Colors.transparent,
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
                            color:
                                vote == -1 ? primaryColor : Colors.transparent,
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
                        const SizedBox(width: 30),
                        IconButton(
                          onPressed: () {
                            showBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return const Text('data');
                              },
                            );
                          },
                          icon: const Icon(Icons.comment),
                        ),
                        const SizedBox(width: 30),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
