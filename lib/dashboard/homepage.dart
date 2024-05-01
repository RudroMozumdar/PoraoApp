import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:porao_app/common/all_import.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          header("Rudro Mozumdar", "assets/images/rudro.jpg"),
          createPostSection(context),
          feedText(),
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
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              style: BorderStyle.solid,
              width: 2,
              color: const Color.fromARGB(255, 230, 230, 230),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                "Have something on your mind?",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: primaryFont,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.add_rounded,
                  size: 60,
                  color: Color.fromARGB(255, 122, 122, 122),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget header(String name, String image) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(image),
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
              Text(
                name,
                style: TextStyle(
                  fontFamily: primaryFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "24Y, Computer Science & Engineering",
                style: TextStyle(
                  fontFamily: primaryFont,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget feedText() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 10),
      width: double.infinity,
      child: Text(
        "Your daily question feed",
        style: TextStyle(
          fontFamily: primaryFont,
          fontSize: 20,
        ),
      ),
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

        return ListView.builder(
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: seconderyColor,
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
                            onTap: (){},
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
                                  width: MediaQuery.of(context).size.width/2.0,
                                  child: GestureDetector(
                                    onTap: (){}, 
                                    child: Text(
                                      post['authorName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: primaryFont,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  )
                                ),

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

                        IconButton( //................... Comment Button
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
                                    (post['upvotes'].length - post['downvotes'].length).toString(), // Total Vote count
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
        );
      },
    );
  }
}
