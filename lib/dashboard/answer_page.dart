import 'package:flutter/material.dart';
import 'package:porao_app/common/all_import.dart';

class AnswerPage extends StatelessWidget {
  final String postID;
  final String authorName;
  final String authorID;
  final String questionContent;
  final String questionTitle;
  final String privacyType;
  final Timestamp postTimestamp;


  const AnswerPage(
    {
      super.key, 
      required this.postID,
      required this.authorName,
      required this.authorID,
      required this.questionContent,
      required this.questionTitle,
      required this.privacyType,
      required this.postTimestamp,
    }
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 16.0), // Remove default padding if any
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
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
                      IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 35, color: Colors.white,),
                        onPressed: () => Navigator.pop(context),                    
                      ),
                    
                      const Text(
                        "POSTED BY",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 214, 214, 214)
                        ),
                      ),
                    
                      IconButton(
                        onPressed: (){}, 
                        icon: Flexible(
                          child: Text(authorName,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    
                      const Text('. ',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),),
                    
                      Text(
                        formatTimeDifference(DateTime.now()
                            .difference(postTimestamp.toDate())),
                        style: TextStyle(
                          fontFamily: primaryFont, 
                          color: Colors.white, 
                          fontSize: Checkbox.width
                          ),
                      ),
                    ],
                  )
                ),
                            
                //const SizedBox(height: 10),
            
                Container(    //........QUESTION TITLE.......//
                  
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
                    
                Container(    //........QUESTION CONTENT.......//
                  
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
                    
                    
                Container(    //........... COMMENT, UPVOTE, DOWNVOTE, SHARE .........//
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: primaryColor, // Adjust the color as needed
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
            
                        IconButton(
                          onPressed: () {
                            final commentController = TextEditingController(); // Create controller here
            
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            
                                return Container(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                    bottom: keyboardHeight,
                                  ),
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: commentController, // Add controller here
                                          decoration: const InputDecoration(
                                            hintText: 'Enter your comment...',
                                          ),
                                        ),
                                      ),
            
                                      IconButton(
                                        onPressed: () async { // Make onPressed async
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
                                                  'parent': "",
                                                  'upvotes': [],
                                                  'downvotes': [],
                                                  'totalReplies': 0,
                                                });
                                            commentController.clear();
                                          } catch (error) {
                                            print('Error sending message: $error');
                                          }
                                        },
                                        icon: const Icon(Icons.send),
                                      ),
            
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.comment, color: Colors.white),
                        ),
            
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white,),
                        ),
                        IconButton(
                          onPressed: () {}, 
                          icon: const Icon(Icons.arrow_downward_rounded, color: Colors.white,),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share, color: Colors.white,),
                        ),
                      ],
                  ),
                ),
                    
                //..................Checks for Replies/Answers and then pastes (if any)...........//
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts') // Replace with your collection name
                      .doc(postID) // Replace with your document ID
                      .collection('answers')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        final documents = snapshot.data!.docs;
                        if (documents.isEmpty) {
                          return Center(
                    
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                    
                        //.............IF ANSWERS ARE PRESENT, IT IS VIEWED HERE...........//
                        // return ListView.builder(
                        //   itemCount: 1,
                        //   itemBuilder: (context, index) => Text(documents[index].id),
                          
                        // );
            
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
                                  return const Center(child: CircularProgressIndicator());
                                default:
                                  final documents = snapshot.data!.docs;
                                  return Expanded(
                                    child: ListView.builder(
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        final data = documents[index].data()! as Map<String, dynamic>;
                                        final String content = data['content'];
                                        final String dpURL = data['dp-url'];
                                        final String author = data['authorName'];
                                        final timeOfCreation = data['createdAt'] as Timestamp;
                                        // ... Access and display other relevant data from the document
                                                            
                                        return Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                  ),
                                                color: Colors.white,
                                              ),
                                      
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 25,
                                                        backgroundImage: NetworkImage(dpURL),
                                                      ),

                                                      Container(
                                                        width: 15,
                                                      ),

                                                      Text(
                                                        author,
                                                        style: const TextStyle(
                                                          fontSize: 18.5,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),

                                                      Container(
                                                        width: 15,
                                                      ),

                                                      Text(
                                                        formatTimeDifference(DateTime.now()
                                                            .difference(timeOfCreation.toDate())),
                                                        style: TextStyle(
                                                          fontFamily: primaryFont, 
                                                          color: Colors.black, 
                                                          fontSize: 15
                                                          ),
                                                      ),
                                                    ],
                                                  ),

                                                  Text(
                                                    content,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.justify,
                                                  ),
                                                ],
                                              ),
                                            );
                                      },
                                    ),
                                  );
                              }
                            },
                          );
            
                        // return Container(
                        //   width: double.infinity,
                        //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        //   margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        //   decoration: const BoxDecoration(
                        //     borderRadius: BorderRadius.all(
                        //       Radius.circular(10),
                        //       ),
                        //     color: Colors.white,
                        //   ),
                  
                        //   child: Text(
                        //     "This is a really tough",
                        //     style: const TextStyle(
                        //       fontSize: 15,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //     textAlign: TextAlign.justify,
                        //   ),
                        // );
                    }
                  }
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240)
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
                FirebaseFirestore.instance.collection('posts').snapshots(),
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
