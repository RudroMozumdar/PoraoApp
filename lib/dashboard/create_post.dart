import 'package:porao_app/common/all_import.dart';
import 'package:porao_app/common/fonts.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _controllerPostContent = TextEditingController();
  final TextEditingController _controllerPostTitle = TextEditingController();
  String privacyStatus = 'private';

  Future<void> createQuestionPost(
      String title, String content, String privacy) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Hero(
          tag: 'createPost',
          child: Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Create Post",
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: primaryFont,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButton(
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: primaryFont,
                              fontSize: 15,
                            ),
                            icon: const Icon(
                              Icons.public,
                              color: Colors.white,
                            ),
                            dropdownColor: primaryButtonColor,
                            value: privacyStatus,
                            items: [
                              DropdownMenuItem(
                                value: 'private',
                                child: Text(
                                  'Private',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: primaryFont,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'public',
                                child: Text(
                                  'Public',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: primaryFont,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                privacyStatus = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    // Title Text Field-----------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _controllerPostTitle,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
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
                    // Content Text Field --------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _controllerPostContent,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
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
                            vertical: 50,
                            horizontal: 10,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.poll_rounded)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.photo)),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              createQuestionPost(
                                _controllerPostTitle.text,
                                _controllerPostContent.text,
                                privacyStatus,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Post Added Successfully.",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            child: const Text('Post'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
