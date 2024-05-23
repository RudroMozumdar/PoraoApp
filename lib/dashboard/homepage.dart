import 'package:flutter/material.dart';
import 'package:porao_app/common/all_import.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  final ScrollController _controller = ScrollController();

  final String userID = FirebaseAuth.instance.currentUser!.uid;

  String calculateAgeFromFirestoreTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final birthDate = timestamp.toDate();
    final duration = now.difference(birthDate);

    // Calculate years using integer division
    final age = duration.inDays ~/ 365;

    return '$age${age > 1 ? 'Y' : 'Y'}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        children: [
          header(),
          createPostSection(context),
          questions(context),
        ],
      ),
    );
  }

  Widget createPostSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTab = 1;
          pageController.animateToPage(
            currentTab,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastEaseInToSlowEaseOut,
          );
        });
        // I need this in future
        // Navigator.of(context).push(HeroDialogRoute(builder: (context) {
        //   return const CreatePost();
        // }));
      },
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(5, 15, 5, 0),
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 1,
                offset: const Offset(0, 4)
              )
            ],
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(218, 255, 225, 0.822),
                Colors.white,
              ],
              stops: [0.1, 0.5],
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            children: [
              Text(
                "Have something on your mind?",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: primaryFont,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.left,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(
                    color: const Color.fromRGBO(212,210,210,0.3),
                    width: 2
                  ),
                  color: const Color.fromRGBO(245,245,245,1.000),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 70,
                  color: Color.fromRGBO(184,204,188,1.000),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final userDoc = snapshot.data!;
        final userData = userDoc.data();

        final age = calculateAgeFromFirestoreTimestamp(userData!['date-of-birth']);
        final qualification = userData['qualifications'];

        String userName = userData['name'];
        String userDP = userData['dp-url'];
        final userQualification = qualification.last;

        return Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(                                     //......POSTER DP..........//
                radius:20,
                backgroundImage: NetworkImage(
                  userDP
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      userName,
                      style: TextStyle(
                        fontFamily: primaryFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "$age, $userQualification",
                      style: TextStyle(
                        fontFamily: primaryFont,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget questions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        final posts = snapshot.data!.docs;

        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(5, 20, 4, 0),
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(218, 255, 225, 0.822),
                    Colors.white,
                  ],
                  stops: [0.1, 0.3],
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(5, 20, 4, 0),
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Your Daily Question Feed",
                          style: TextStyle(
                            fontFamily: primaryFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
            
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot post = posts[index];
                      final timestamp = post['createdAt'] as Timestamp;
                      var vote = 0;
                  
                      // Check if user has already voted
                      if (post['upvotes'].contains(Auth().currentUser?.uid)) {
                        vote = 1;
                      } else if (post['downvotes']
                          .contains(FirebaseAuth.instance.currentUser?.uid)) {
                        vote = -1;
                      }
                  
                      // final answerController = TextEditingController();
                      DocumentReference docRef =
                          FirebaseFirestore.instance.collection('posts').doc(post.id);
                  
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromRGBO(177, 148, 147, 0.5),
                              width: 2
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                child: Row(
                                  children: [
                                    // Image
                                    GestureDetector(
                                      onTap: () {
                                        String authorID = post['authorId'];
                                        MaterialPageRoute
                                        (
                                          builder: (context) => PublicProfile(uid: authorID,)                              
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(post['dp-url']),
                                      ),
                                    ),
                  
                                    // Name
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width:
                                                  MediaQuery.of(context).size.width / 2.0,
                                              child: GestureDetector(
                                                  onTap: () {},
                                                  child: Text(
                                                    post['authorName'],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: primaryFont,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ))),
                                          Text(
                                            formatTimeDifference(DateTime.now()
                                                .difference(timestamp.toDate())),
                                            style: TextStyle(fontFamily: primaryFont),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  post['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: primaryFont,
                                  ),
                                ),
                                subtitle: ExpandableText(
                                  post['content'],
                                  expandText: 'show more.',
                                  maxLines: 5,
                                  linkColor: Colors.blue,
                                  animation: true,
                                  collapseText: '...show less',
                                  expandOnTextTap: true,
                                  collapseOnTextTap: true,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontFamily: primaryFont,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    //................... Comment Button
                                    onPressed: () {
                                      // Get the question data (replace with your actual way of accessing data)
                                      final String docID = post.id;
                                      final String authorName = post['authorName'];
                                      final String authorID = post['authorId'];
                                      final String content = post['content'];
                                      final String title = post['title'];
                                      final String privacy = post['privacy'];
                                      final timestamp = post['createdAt'] as Timestamp;
                                      final String posterDP = post['dp-url'];
                  
                                      // Navigate to the AnswerPage with data
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AnswerPage(
                                            postID: docID,
                                            authorName: authorName,
                                            authorID: authorID,
                                            questionContent: content,
                                            questionTitle: title,
                                            privacyType: privacy,
                                            postTimestamp: timestamp,
                                            voteCount: vote,
                                            posterDP: posterDP,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.comment),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (vote == 0) {
                                            docRef.update({
                                              'upvotes': FieldValue.arrayUnion(
                                                  [Auth().currentUser?.uid]),
                                            });
                                          } else if (vote == -1) {
                                            docRef.update({
                                              'downvotes': FieldValue.arrayRemove(
                                                  [Auth().currentUser?.uid]),
                                            });
                                            docRef.update({
                                              'upvotes': FieldValue.arrayUnion(
                                                  [Auth().currentUser?.uid]),
                                            });
                                          } else {
                                            docRef.update({
                                              'upvotes': FieldValue.arrayRemove(
                                                  [Auth().currentUser?.uid]),
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.arrow_upward_rounded),
                                        tooltip: 'Upvote',
                                        color: vote == 1 ? Colors.blue : Colors.black,
                                      ), // Added missing closing curly brace here
                  
                                      const SizedBox(
                                        width: 25,
                                      ),
                  
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            (post['upvotes'].length -
                                                    post['downvotes'].length)
                                                .toString(), // Total Vote count
                                          ),
                                        ),
                                      ),
                  
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      // -----------------------------------------------------------------Downvote Button
                                      IconButton(
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
                                        color: vote == -1 ? Colors.blue : Colors.black,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
