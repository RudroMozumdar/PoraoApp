import 'package:porao_app/common/all_import.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  String formatTimeDifference(Duration difference) {
    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;

    if (days > 0) {
      return '$days day${days > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours hr${hours > 1 ? 's' : ''}';
    } else if (minutes > 0) {
      return '$minutes min${minutes > 1 ? 's' : ''}';
    } else {
      return '$seconds sec${seconds > 1 ? 's' : ''}';
    }
  }

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
                          onPressed: () {},
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
