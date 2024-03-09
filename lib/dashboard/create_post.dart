import 'package:porao_app/common/all_import.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _controllerPostContent = TextEditingController();
  final TextEditingController _controllerPostTitle = TextEditingController();

  Future<void> createQuestionPost(String title, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // Handle user not authenticated case
    }

    final docRef = FirebaseFirestore.instance.collection('posts').doc();
    //final postId = docRef.id;

    await docRef.set({
      'authorId': user.uid,
      // 'privacy': 1,
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
                    Text(
                      "Create Post",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: primaryFont,
                        color: Colors.white,
                      ),
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
                              );
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
