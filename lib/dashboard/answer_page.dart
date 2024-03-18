import 'package:porao_app/common/all_import.dart';

class AnswerPage extends StatelessWidget {
  final String questionTitle;
  final String questionContent;

  const AnswerPage(
      {super.key, required this.questionTitle, required this.questionContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Answer'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, bottom: 16.0), // Remove default padding if any
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(questionContent),
            const SizedBox(height: 10), // Add spacing before the container
            SizedBox(
              width: double.infinity, // Make the container fill available width
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor, // Adjust the color as needed
                  borderRadius: BorderRadius.circular(50),
                ),
                // Remove padding for full width usage (optional)
                // padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            final keyboardHeight =
                                MediaQuery.of(context).viewInsets.bottom;

                            return Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      keyboardHeight), // Adjust padding dynamically
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Enter your comment...',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.send),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.comment),
                    ),
                    IconButton(
                      onPressed: () {}, // Implement button logic
                      icon: const Icon(Icons.arrow_upward_rounded),
                    ),
                    IconButton(
                      onPressed: () {}, // Implement button logic
                      icon: const Icon(Icons.arrow_downward_rounded),
                    ),
                    IconButton(
                      onPressed: () {}, // Implement button logic
                      icon: const Icon(Icons.share),
                    ),
                  ],
                ),
              ),
            ),
            // Add your answer input field and submit button here
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class AnswerSection extends StatefulWidget {
  const AnswerSection({super.key});

  @override
  State<AnswerSection> createState() => _AnswerSection();
}

class _AnswerSection extends State<AnswerSection> {
  List<bool> selectedList = [false, false, false];
  List<int> voteCounter = [0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('comments').snapshots(),
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

              final comments = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true, // Correction: Added closing parenthesis
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot comment = comments[index];
                  final timestamp = comment['createdAt'] as Timestamp;
                  var vote = 0;

                  // Check if user has already voted
                  if (comment['upvotes'].contains(Auth().currentUser?.uid)) {
                    vote = 1;
                  } else if (comment['downvotes']
                      .contains(FirebaseAuth.instance.currentUser?.uid)) {
                    vote = -1;
                  }

                  final answerController = TextEditingController();
                  DocumentReference docRef = FirebaseFirestore.instance
                      .collection('comments')
                      .doc(comment.id);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: seconderyColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(comment['comment']),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              formatTimeDifference(DateTime.now()
                                  .difference(timestamp.toDate())),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: vote == 1
                                      ? primaryColor
                                      : Colors.transparent,
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
                                  color:
                                      vote == 1 ? Colors.white : Colors.black,
                                ),
                              ),
                              Text((comment['upvotes'].length -
                                      comment['downvotes'].length)
                                  .toString()),
                              // -----------------------------------------------------------------Downvote Button
                              Container(
                                decoration: BoxDecoration(
                                  color: vote == -1
                                      ? primaryColor
                                      : Colors.transparent,
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
                                  icon:
                                      const Icon(Icons.arrow_downward_rounded),
                                  tooltip: 'Downvote',
                                  color:
                                      vote == -1 ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Get the question data (replace with your actual way of accessing data)
                                  final String title = comment['title'];
                                  final String content = comment['content'];

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
          ),
        ],
      ),
    );
  }
}
