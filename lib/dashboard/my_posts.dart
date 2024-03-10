import 'package:porao_app/common/all_import.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
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

            final answerController = TextEditingController();

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
                    // ----------------------------------------------------------------------Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // -------------------------------------------------------------------Upvote button
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
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: seconderyButtonColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: TextField(
                                            controller: answerController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                              hintText: 'Write your answer',
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              hintStyle: TextStyle(
                                                fontFamily: primaryFont,
                                                fontSize: 15,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            var xml = {
                                              "authorId":
                                                  Auth().currentUser?.uid,
                                              "content": answerController.text,
                                              "createdAt": Timestamp.now(),
                                            };
                                            docRef.update({
                                              'answers':
                                                  FieldValue.arrayUnion([xml])
                                            });
                                          },
                                          child: const Text('Submit'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
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
