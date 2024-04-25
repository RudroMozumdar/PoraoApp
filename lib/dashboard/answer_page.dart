import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:porao_app/common/all_import.dart';

class Stack<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  E get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();

  int length() => _list.length;
}

class AnswerPage extends StatelessWidget {
  final String postID;
  final String authorName;
  final String authorID;
  final String questionContent;
  final String questionTitle;
  final String privacyType;
  final Timestamp postTimestamp;
  final replies = Stack<Map<String, dynamic>>();
  final repliesID = Stack<String>();
  final db = FirebaseFirestore.instance;


  AnswerPage({
    super.key,
    required this.postID,
    required this.authorName,
    required this.authorID,
    required this.questionContent,
    required this.questionTitle,
    required this.privacyType,
    required this.postTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 16.0), // Remove default padding if any
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //...........................COLUMN CHILDRENS................//
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 60, bottom: 20),
                      color: primaryColor,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 35,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            "POSTED BY",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 214, 214, 214)),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Flexible(
                              child: Text(
                                authorName,
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Text(
                            '. ',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            formatTimeDifference(DateTime.now()
                                .difference(postTimestamp.toDate())),
                            style: TextStyle(
                                fontFamily: primaryFont,
                                color: Colors.white,
                                fontSize: Checkbox.width),
                          ),
                        ],
                      )),

                  //const SizedBox(height: 10),

                  Container(
                    //........QUESTION TITLE.......//

                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),

                    child: Text(
                      questionTitle,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  Container(
                    //........QUESTION CONTENT.......//

                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),

                    child: Text(
                      questionContent,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  Container(
                    //...........MAIN COMMENT, UPVOTE, DOWNVOTE, SHARE .........//
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: primaryColor, // Adjust the color as needed
                      borderRadius: BorderRadius.circular(10),
                    ),
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        IconButton( //..................... MAIN POST COMMENT BUTTON..................//
                          onPressed: () {
                            final commentController = TextEditingController();
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                  top: 20.0,
                                  right: 20.0,
                                  left: 20.0,
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(hintText: 'Type reply here'),
                                      controller: commentController,
                                      autofocus: true,
                                      onSubmitted: (text) {
                                        print("Reply: $text");
                                      },
                                    ),

                                    IconButton(  //.............Send Button For Comment...........//
                                      onPressed: () async {
                                        final firestore = FirebaseFirestore.instance;
                                        final commentContent = commentController.text;
                                        String? name;
                                        String? imageUrl;
                                        String currentUser = FirebaseAuth.instance.currentUser!.uid;

                                        try {
                                          final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(currentUser)
                                          .get();

                                          if (documentSnapshot.exists) {
                                            final Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
                                            name = data['name'];
                                            imageUrl = data['dp-url'];
                                          } else {
                                            print('Document does not exist');
                                          }

                                          await firestore
                                              .collection('posts')
                                              .doc(postID)
                                              .collection('answers')
                                              .doc()
                                              .set({
                                                'content': commentContent,
                                                'createdAt': FieldValue.serverTimestamp(),
                                                'authorID': FirebaseAuth.instance.currentUser!.uid,
                                                'authorName': name,
                                                'dp-url': imageUrl,
                                                'level': 0,
                                                'children': [],
                                                'upvotes': [],
                                                'downvotes': [],
                                                'totalReplies': 0,
                                              },
                                          );
                                          commentController.clear();
                                        } catch (error) {
                                          print(
                                              'Error sending message: $error');
                                        }finally {
                                          Navigator.pop(context); // Close the bottomsheet regardless of success/failure
                                        } 
                                      },
                                      icon: const Icon(Icons.send),
                                    ),                                                            
                                ],
                              ),
                            ),
                          );
                        },
                         icon: const Icon(Icons.comment, color: Colors.white),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.white,
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //..................Checks for Replies/Answers and then pastes (if any)...........//
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postID)
                          .collection('answers')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          default:              //................IF NO THREADS ARE FOUND ............//
                            final documents = snapshot.data!.docs;
                            if (documents.isEmpty) {
                              return Center(
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "No Answers Yet!",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(postID)
                                  .collection('answers')
                                  .where('level', isEqualTo: 0)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return const Center(
                                      child: CircularProgressIndicator());
                                  default:
                                    final documents = snapshot.data!.docs;
                                    return ListView.builder (
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        final data = documents[index].data()! as Map<String, dynamic>;
                                        DocumentSnapshot comment = documents[index];
                                        String curDocID = comment.id;
                                        final String content = data['content'];
                                        final String dpURL = data['dp-url'];
                                        final String author = data['authorName'];
                                        final timeOfCreation = data['createdAt'] as Timestamp;
                                        final int level = data['level'];
                                        double newLevel = level + 0.0;
                                        newLevel *= 10;

                                        return buildReplyBox(dpURL, author, timeOfCreation, content, context, curDocID, newLevel);
                                      },
                                    );
                                }
                              },
                            );
                        }
                      })
                ],
              ),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240));
  }

  Widget replyButtons (BuildContext context, String curDocID) {
    //............... REACTION BUTTONS FOR REPLY COMMENTS............//
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        IconButton(
          onPressed: () {
            final commentController = TextEditingController();
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                  right: 20.0,
                  left: 20.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(hintText: 'Type reply here'),
                      controller: commentController,
                      autofocus: true,
                      onSubmitted: (text) {
                        print("Reply: $text");
                      },
                    ),

                    IconButton(
                      onPressed: () async {
                        final replyContent = commentController.text;
                        String? name;
                        String? imageUrl;
                        String currentUser = FirebaseAuth.instance.currentUser!.uid;

                        try {
                          final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser)
                          .get();

                          if (documentSnapshot.exists) {
                            final Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
                            name = data['name'];
                            imageUrl = data['dp-url'];
                          } else {
                            print('Document does not exist');
                          }

                          int? level;

                          try {
                            final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                              .collection('posts')
                              .doc(postID)
                              .collection('answers')
                              .doc(curDocID)
                              .get();

                              final Map<String, dynamic> subData = documentSnapshot.data()! as Map<String, dynamic>;
                              level = subData['level'];

                          } catch(error) {
                              print(
                                'Error sending message: $error');
                          }

                          final newLevel = level! + 1;

                          Future<String> addReplyToFirestore(String postID, String replyContent, String? name, String? imageUrl, int newLevel) async {
                            final CollectionReference repliesRef = FirebaseFirestore.instance
                                .collection('posts')
                                .doc(postID)
                                .collection('answers');

                            final DocumentReference newReplyRef = await repliesRef.add({
                              'content': replyContent,
                              'createdAt': FieldValue.serverTimestamp(),
                              'authorID': FirebaseAuth.instance.currentUser!.uid,
                              'authorName': name,
                              'dp-url': imageUrl,
                              'level': newLevel,
                              'children': [],
                              'upvotes': [],
                              'downvotes': [],
                              'totalReplies': 0,
                            });

                            return newReplyRef.id; // Return the DocumentReference of the newly created document
                           }
                           String? newReplyRef;

                          try{
                            newReplyRef = await addReplyToFirestore(postID, replyContent, name, imageUrl, newLevel);
                          }  catch (error) {
                              print('Error sending message: $error');
                          } finally {
                            Navigator.pop(context); // Close the bottomsheet regardless of success/failure
                          }                  

                          final parentRef = db.collection('posts').doc(postID).collection('answers').doc(curDocID);

                          parentRef.update({
                            "children": FieldValue.arrayUnion([newReplyRef]),
                            "totalReplies": FieldValue.increment(1),
                          });

                          commentController.clear();
                        } catch (error) {
                          print(
                              'Error sending message: $error');
                        }
                      },
                      icon: const Icon(Icons.send),
                    ),                                                                
                  ],
                ),
              ),
            );
          },
          icon: const Icon(Icons.comment, color: Colors.grey),
        ),


        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.grey,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_downward_rounded,
            color: Colors.grey,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.share,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }  

  Widget buildReplyBox (String dpURL, String author, Timestamp timeOfCreation, String content, BuildContext context, String curDocID, double forPadding) {

    return Container(  //............CONTAINS INDIVIDUAL REPLIES........//
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: forPadding),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(  //............ DISPLAY PICTURE..........//
                  radius: 20,
                  backgroundImage:
                      NetworkImage(dpURL),
                ),
        
                Container(  
                  width: 10,
                ),
        
                Text(  //.................... NAME OF AUTHOR ........//
                  author,
                  style: const TextStyle(
                    fontSize: 18.5,
                    fontWeight:
                        FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
        
                Container(
                  width: 15,
                ),
        
                Text(
                  formatTimeDifference(
                      DateTime.now()
                          .difference(
                              timeOfCreation
                                  .toDate())),
                  style: TextStyle(
                      fontFamily: primaryFont,
                      color: Colors.black,
                      fontSize: 13),
                ),
              ],
            ),
        
            Container(
              height: 5,
              alignment: Alignment.bottomLeft,
            ),
        
            Container(  //............... CONTENT OF THE REPLY............//
              alignment: Alignment.bottomLeft,
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.normal,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
        
            //............... REACTION BUTTONS FOR REPLY COMMENTS............//
            replyButtons(context, curDocID),      
        
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postID)
                  .collection('answers')
                  .doc(curDocID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final documentData = snapshot.data!.data()! as Map<String, dynamic>;
                final List<dynamic> childrenArray = documentData['children'];
        
                if (childrenArray.isEmpty){
                  return Container();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: childrenArray.length,
                    itemBuilder: (context, index) {
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postID)
                          .collection('answers')
                          .doc(childrenArray[index])
                          .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final childData = snapshot.data!.data()! as Map<String, dynamic>;
        
                            final String replyID = snapshot.data!.id;
                            final String content = childData['content'];
                            final String dpURL = childData['dp-url'];
                            final String author = childData['authorName'];
                            final timeOfCreation = childData['createdAt'] as Timestamp;
                            final int level = childData['level'];
                            double newLevel = level + 0.0;
                            newLevel *= 10;
        
                            return buildReplyBox(dpURL, author, timeOfCreation, content, context, replyID, newLevel);
                          }
                        );
                    }
                  );
                }
        
              }
            )
        
          ],
        ),
      ),
    );
  }

}

class RecursiveDocumentPrinter extends StatelessWidget {
  final String parentDocID;

  const RecursiveDocumentPrinter({Key? key, required this.parentDocID})
      : super(key: key);

  
  Widget temp () {
    return Text(parentDocID);
  }

  Future<Widget> _fetchDataAndPrint(BuildContext context) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('your_collection').doc(parentDocID);
    final docSnapshot = await docRef.get();

    final data = docSnapshot.data()!;

    // Print specific fields
    Text(data['content']);

    // Check for "children" field and handle empty case
    final children = data['children'] as List<String>?;
    if (children?.isEmpty ?? true) {
      return Container(); // Correct: exit if children is empty or null
    }

    // Recursive call using ListView.builder
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate async operation (remove if not needed)
    return Future.value(ListView.builder(
      shrinkWrap: true, // Adjust as needed
      physics: const NeverScrollableScrollPhysics(), // Adjust as needed
      itemCount: children!.length,
      itemBuilder: (context, index) {
        final childDocID = children[index];
        return RecursiveDocumentPrinter(parentDocID: childDocID);
      },
    ));
  } catch (error) {
    print('Error fetching data: $error');
  }

  return Text("data");
}


@override
Widget build(BuildContext context) {
  return FutureBuilder<void>(
    future: _fetchDataAndPrint(context),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(); // You can customize the empty state here
    },
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

                  // final answerController = TextEditingController();
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
