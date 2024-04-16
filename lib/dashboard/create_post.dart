import 'package:porao_app/common/all_import.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _controllerPostContent = TextEditingController();
  final TextEditingController _controllerPostTitle = TextEditingController();
  final TextEditingController _controllerTags = TextEditingController();
  String privacyStatus = 'public';
  List<String> listTags = [];

  Future<void> createQuestionPost(String title, String content, String privacy,
      List<String> tagsList) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final docRef = FirebaseFirestore.instance.collection('posts').doc();

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user.uid)
        .get();

    String name = snapshot.data()!['name'];
    String dpurl = snapshot.data()!['dp-url'];

    await docRef.set({
      'tags': tagsList,
      'dp-url': dpurl,
      'authorId': user.uid,
      'authorName': name,
      'privacy': privacy,
      'title': title,
      'content': content,
      'createdAt': Timestamp.now(),
      'upvotes': [],
      'downvotes': [],
      'answers': {},
    });
    setState(() {
      listTags.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Ask a public question",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: primaryFont,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: DropdownButton(
                //     style: TextStyle(
                //       color: const Color.fromARGB(255, 0, 0, 0),
                //       fontFamily: primaryFont,
                //       fontSize: 15,
                //     ),
                //     icon: const Icon(
                //       Icons.public,
                //       color: Color.fromARGB(255, 0, 0, 0),
                //     ),
                //     dropdownColor: primaryButtonColor,
                //     value: privacyStatus,
                //     items: [
                //       DropdownMenuItem(
                //         value: 'private',
                //         child: Text(
                //           'Private',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontFamily: primaryFont,
                //             fontSize: 15,
                //           ),
                //         ),
                //       ),
                //       DropdownMenuItem(
                //         value: 'public',
                //         child: Text(
                //           'Public',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontFamily: primaryFont,
                //             fontSize: 15,
                //           ),
                //         ),
                //       ),
                //     ],
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         privacyStatus = newValue!;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
            // ----------------------------------------------------------Title Text Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                controller: _controllerPostTitle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  hintText: 'Title of yout question, please.',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  hintStyle: TextStyle(
                    fontFamily: primaryFont,
                    fontSize: 15,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // --------------------------------------------------------Content Text Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                maxLines: 5,
                controller: _controllerPostContent,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  hintText: 'Elaborate your question...',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  hintStyle: TextStyle(
                    fontFamily: primaryFont,
                    fontSize: 15,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // ----------------------------------------------------------Tags text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.75,
                    child: TextField(
                      controller: _controllerTags,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        hintText: 'Tags',
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        hintStyle: TextStyle(
                          fontFamily: primaryFont,
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        listTags.add(_controllerTags.text);
                        _controllerTags.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: Size(screenWidth * 0.20, 48),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontFamily: primaryFont,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // ------------------------------------------------------------Tags Grid
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 110,
                mainAxisExtent: 40,
              ),
              itemCount: listTags.length,
              itemBuilder: (context, index) {
                return Chip(
                  label: Text(
                    listTags[index],
                    style: TextStyle(fontFamily: primaryFont),
                  ),
                  backgroundColor: seconderyColor,
                  side: BorderSide.none,
                  onDeleted: () {
                    setState(() {
                      listTags.removeAt(index);
                    });
                  },
                );
              },
            ),
            // -------------------------------------------------------Post
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.poll_rounded)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.photo)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontFamily: primaryFont,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      createQuestionPost(
                        _controllerPostTitle.text,
                        _controllerPostContent.text,
                        privacyStatus,
                        listTags,
                      );
                      setState(() {
                        currentTab = 1;
                        pageController.animateToPage(
                          currentTab,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastEaseInToSlowEaseOut,
                        );
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Post Added Successfully.",
                            style: TextStyle(
                              color: Colors.green,
                              fontFamily: primaryFont,
                            ),
                          ),
                        ),
                      );
                      _controllerPostContent.clear();
                      _controllerPostTitle.clear();
                      _controllerTags.clear();
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    'Similer questions',
                    style: TextStyle(fontFamily: primaryFont, fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
