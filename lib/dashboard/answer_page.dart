import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
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

class AnswerPage extends StatefulWidget {

  final String postID;
  final String authorName;
  final String authorID;
  final String questionContent;
  final String questionTitle;
  final String privacyType;
  final Timestamp postTimestamp;
  final db = FirebaseFirestore.instance;
  final int voteCount;

  AnswerPage({
    Key? key,
    required this.postID,
    required this.authorName,
    required this.authorID,
    required this.questionContent,
    required this.questionTitle,
    required this.privacyType,
    required this.postTimestamp,
    required this.voteCount,
  }) : super(key: key);

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  int vote = 0;
  bool _isUpvoteSelected = false;
  bool _isDownvoteSelected = false;

  void _toggleUpvote() {
    setState(() {
      _isUpvoteSelected = !_isUpvoteSelected;
      if(_isUpvoteSelected){
        _isDownvoteSelected = false;
      }
    });
  }

  void _toggleDownvote() {
    setState(() {
      _isDownvoteSelected = !_isDownvoteSelected;
      if(_isDownvoteSelected){
        _isUpvoteSelected = false;
      }
    });
  }

  void upvote() async {
    setState(() {
      vote = 1;
    });
  }

  void neutralVote() async {
    setState(() {
      vote = 0;
    });
  }

  void downvote()async {
    setState(() {
      vote = -1;
    });
  }

  @override
  void initState() {
    super.initState();
    vote = widget.voteCount;

    if (widget.voteCount == -1){
      _isUpvoteSelected = false;
      _isDownvoteSelected = true;
      
    }
    if (widget.voteCount == 0){
      _isUpvoteSelected = false;
      _isDownvoteSelected = false;
    }
    if (widget.voteCount == 1){
      _isUpvoteSelected = true;
      _isDownvoteSelected = false;
    }
  }

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
                                widget.authorName,
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          // const Text(
                          //   '. ',
                          //   style: TextStyle(
                          //     fontSize: 25,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          Text(
                            formatTimeDifference(DateTime.now()
                                .difference(widget.postTimestamp.toDate())),
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
                      widget.questionTitle,
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
                      widget.questionContent,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  Container(
                    //...........MAIN COMMENT,UPVOTE, DOWNVOTE, SHARE .........//
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

                                          final updatePost = widget.db.collection('posts').doc(widget.postID);

                                          updatePost.update({
                                            "answerCount": FieldValue.increment(1),
                                          });

                                          await firestore
                                              .collection('posts')
                                              .doc(widget.postID)
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

                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [                                
                          IconButton(
                            onPressed: () async {
                              DocumentReference docRef = FirebaseFirestore.instance.collection('posts').doc(widget.postID);
                              final DocumentSnapshot docSnap = await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(widget.postID)
                                .get();

                              setState(() {
                                if (docSnap['upvotes'].contains(FirebaseAuth.instance.currentUser?.uid)) {
                                  upvote();
                                } else if (docSnap['downvotes'].contains(FirebaseAuth.instance.currentUser?.uid)) {
                                  downvote();
                                } else {
                                  neutralVote();
                                }
                              });

                              if (vote == 0) {
                                docRef.update({
                                  'upvotes': FieldValue.arrayUnion([Auth().currentUser?.uid]),
                                });
                              } else if (vote == -1) {
                                docRef.update({
                                  'downvotes': FieldValue.arrayRemove([Auth().currentUser?.uid]),
                                });
                                docRef.update({
                                  'upvotes': FieldValue.arrayUnion([Auth().currentUser?.uid]),
                                });
                              } else {
                                docRef.update({
                                  'upvotes': FieldValue.arrayRemove([Auth().currentUser?.uid]),
                                });
                              }

                              _toggleUpvote();
                            },
                            icon: const Icon(Icons.arrow_upward_rounded),
                            tooltip: 'upvote',
                            color: _isUpvoteSelected ? Colors.cyan : Colors.white,
                          ),

                          const SizedBox(
                            width: 25,
                          ),

                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryButtonColor,
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: voteCount(context, widget.db.collection('posts').doc(widget.postID).snapshots()),
                              ),
                          ),

                          const SizedBox(
                            width: 25,
                          ),
                          
                            // -----------------------------------------------------------------downvote Button
                          IconButton(
                              onPressed: () async {
                                DocumentReference docRef = FirebaseFirestore.instance.collection('posts').doc(widget.postID);
                                final DocumentSnapshot docSnap = await FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(widget.postID)
                                  .get();

                                // Check if user has already voted
                                setState(() {
                                  if (docSnap['upvotes'].contains(FirebaseAuth.instance.currentUser?.uid)) {
                                    upvote();
                                  } else if (docSnap['downvotes'].contains(FirebaseAuth.instance.currentUser?.uid)) {
                                    downvote();
                                  } else {
                                    neutralVote();
                                  }
                                });

                                if (vote == 0) {
                                  docRef.update({
                                    'downvotes': FieldValue.arrayUnion([Auth().currentUser?.uid])
                                  });
                                } else if (vote == 1) {
                                  docRef.update({
                                    'upvotes': FieldValue.arrayRemove([Auth().currentUser?.uid])
                                  });
                                  docRef.update({
                                    'downvotes': FieldValue.arrayUnion([Auth().currentUser?.uid])
                                  });
                                } else {
                                  docRef.update({
                                    'downvotes': FieldValue.arrayRemove([Auth().currentUser?.uid])
                                  });
                                }

                                _toggleDownvote();
                              },
                              icon: const Icon(Icons.arrow_downward_rounded),
                              tooltip: 'downvote',
                              color: _isDownvoteSelected ? Colors.cyan : Colors.white,
                            ),
                          ],
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
                          .doc(widget.postID)
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
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Answers Yet!",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),

                                        SizedBox(height: 20),

                                        Text(
                                          "Be the first to comment.",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(widget.postID)
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

                                        int votes = 0;

                                        // Check if user has already voted
                                        if (data['upvotes'].contains(Auth().currentUser?.uid)) {
                                          votes = 1;
                                        } else if (data['downvotes']
                                            .contains(FirebaseAuth.instance.currentUser?.uid)) {
                                          votes = -1;
                                        }

                                        return buildReplyBox(dpURL, author, timeOfCreation, content, context, curDocID, newLevel, votes);
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

  Widget replyButtons (BuildContext context, String curDocID, int votes) {
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
                              .doc(widget.postID)
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
                            newReplyRef = await addReplyToFirestore(widget.postID, replyContent, name, imageUrl, newLevel);
                          }  catch (error) {
                              print('Error sending message: $error');
                          } finally {
                            Navigator.pop(context); // Close the bottomsheet regardless of success/failure
                          }                  

                          final parentRef = widget.db.collection('posts').doc(widget.postID).collection('answers').doc(curDocID);

                          parentRef.update({
                            "children": FieldValue.arrayUnion([newReplyRef]),
                            "totalReplies": FieldValue.increment(1),
                          });

                          final updatePost = widget.db.collection('posts').doc(widget.postID);

                          updatePost.update({
                            "answerCount": FieldValue.increment(1),
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
          onPressed: () async {
            DocumentReference docRef = FirebaseFirestore.instance.collection('posts').doc(widget.postID).collection('answers').doc(curDocID);                          

            if (votes == 0) {
              docRef.update({
                'upvotes': FieldValue.arrayUnion([Auth().currentUser?.uid]),
              });
            } else if (votes == -1) {
              docRef.update({
                'downvotes': FieldValue.arrayRemove([Auth().currentUser?.uid]),
              });
              docRef.update({
                'upvotes': FieldValue.arrayUnion([Auth().currentUser?.uid]),
              });
            } else {
              docRef.update({
                'upvotes': FieldValue.arrayRemove([Auth().currentUser?.uid]),
              });
            }
          },
          icon: const Icon(Icons.arrow_upward_rounded, size: 30,),
          tooltip: 'upvote',
          color: votes == 1 ? Colors.cyan : Colors.grey,
        ),

        const SizedBox(
          width: 10,
        ),

        Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle            
          ),

          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: voteCount(context, widget.db.collection('posts').doc(widget.postID).collection('answers').doc(curDocID).snapshots()),
          ),
          
        ),

        const SizedBox(
          width: 10,
        ),
              
        // -----------------------------------------------------------------Downvote Button
        IconButton(
          onPressed: () async {
            DocumentReference docRef = FirebaseFirestore.instance.collection('posts').doc(widget.postID).collection('answers').doc(curDocID);                   

            if (votes == 0) {
              docRef.update({
                'downvotes': FieldValue.arrayUnion(
                    [Auth().currentUser?.uid])
              });
            } else if (votes == 1) {
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
          icon: const Icon(Icons.arrow_downward_rounded, size: 30,),
          tooltip: 'Downvote',
          color: votes == -1 ? Colors.cyan : Colors.grey,             
        ),          
      ],
    );
  }  

  Widget buildReplyBox (String dpURL, String author, Timestamp timeOfCreation, String content, BuildContext context, String curDocID, double forPadding, int votes) {

    return Container(  //............CONTAINS INDIVIDUAL REPLIES........//
      width: double.infinity,
      padding: forPadding == 0.0 ? const EdgeInsets.fromLTRB(20, 20, 20, 20) : const EdgeInsets.fromLTRB(20, 0, 0, 0), //level wise padding
      margin: forPadding == 0.0 ? const EdgeInsets.fromLTRB(10, 0, 10, 10) : const EdgeInsets.all(0.0), //level wise margin
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
            replyButtons(context, curDocID, votes),      
        
            StreamBuilder<DocumentSnapshot>( //..........CHECKS IF REPLIES HAVE FURTHER CHILDREN OR NOT..........//
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postID)
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
        
                if (childrenArray.isEmpty){//..............RETURNS NULL IF NO CHILDREN FOUND............//
                  return Container();
                } else {
                  return ListView.builder(//.............IF CHILDREN FOUND => FETCHES ALL CHILDREN REPLY USING LISTVIEW.BUILDER...//
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: childrenArray.length,
                    itemBuilder: (context, index) {
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postID)
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

                            var votess = 0;

                            // Check if user has already voted
                            if (childData['upvotes'].contains(Auth().currentUser?.uid)) {
                              votess = 1;
                            } else if (childData['downvotes']
                                .contains(FirebaseAuth.instance.currentUser?.uid)) {
                              votess = -1;
                            }
        
                            return buildReplyBox(dpURL, author, timeOfCreation, content, context, replyID, newLevel, votess); //.............RECURSION CALL TO CHECK ALL CHILDREN IN THE TREE.....//
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

  Widget voteCount(BuildContext context, Stream<DocumentSnapshot<Map<String, dynamic>>> ref) {
    int upvoteCount = 0;
    int downvoteCount = 0;
    List<dynamic> upvote, downvote;

    // Function to fetch and return vote count
    return StreamBuilder<DocumentSnapshot> (
      stream: ref,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final documentData = snapshot.data!.data()! as Map<String, dynamic>;
        upvote = documentData['upvotes'];
        downvote = documentData['downvotes'];
        upvoteCount = upvote.length;
        downvoteCount = downvote.length;
        return Text(
          (upvoteCount - downvoteCount).toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        );
      }    
    );  
  }

  bool colorPick(BuildContext context, Stream<DocumentSnapshot<Map<String, dynamic>>> ref) {
    bool color = true;

    StreamBuilder<DocumentSnapshot>(
      stream: ref,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final documentData = snapshot.data!.data()! as Map<String, dynamic>;
          final upvote = documentData['upvotes'];
          final downvote = documentData['downvotes'];
          if (upvote.contains(FirebaseAuth.instance.currentUser!.uid)) {
            color = true;
          } else if (downvote.contains(FirebaseAuth.instance.currentUser?.uid)) {
            color = false;
          }
        }

        return Container();
      },
    );

    return color;
  }

  Widget userVote () {

    return StreamBuilder<DocumentSnapshot>(
      stream: widget.db.collection('posts').doc(widget.postID).snapshots(),
      builder: (context, snapshot) {
        final documentData = snapshot.data!.data()! as Map<String, dynamic>;
        List<dynamic> upvotes = documentData['upvotes'];
        List<dynamic> downvotes = documentData['downvotes'];

        if (upvotes.contains(FirebaseAuth.instance.currentUser?.uid)) {
          upvote();
        } else if (downvotes.contains(FirebaseAuth.instance.currentUser?.uid)) {
          downvote();
        } else {
          neutralVote();
        }
        return Text(vote.toString());

      });
  }
}