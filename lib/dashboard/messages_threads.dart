import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:porao_app/common/all_import.dart';

class MessagesThreads extends StatefulWidget {
  const MessagesThreads({super.key});

  @override
  State<MessagesThreads> createState() => _MessagesThreads();
}

class _MessagesThreads extends State<MessagesThreads> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>>? filteredDocuments;

  var currentUser = FirebaseAuth.instance.currentUser;

  late Timer _refreshTimer;

  int _selectedIndex = 0;

  Future<void> _fetchAndFilterMessages() async {
    filteredDocuments = await fetchAndFilterByUserId(currentUser!.uid);
    setState(() {});
  }

  String _formatTimestampForDisplay(dynamic timestampValue) {
    Timestamp firebaseTimestamp = timestampValue as Timestamp;
    DateTime dateTime = firebaseTimestamp.toDate();
    DateTime now = DateTime.now();

    // difference in days
    int differenceInDays = now.difference(dateTime).inDays;

    // format pattern based on difference in days
    String formattedDate;
    if (differenceInDays == 0) {
      //within Today
      formattedDate = DateFormat('h:mm a').format(dateTime);
    } else if (differenceInDays == 1) {
      // at least Yesterday
      formattedDate = 'Yesterday\n ${DateFormat('h:mm a').format(dateTime)}';
    } else if (differenceInDays < 7) {
      // Within a week, show weekday abbreviation
      formattedDate = '${DateFormat('EEE').format(dateTime)}, ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      // More than a week, show full date
      formattedDate = DateFormat('d MMM, yyyy').format(dateTime);
    }

    return formattedDate;
  }


  Future<List<Map<String, dynamic>>> fetchAndFilterByUserId(
    String currentUserId,
  ) async {
    final collectionRef = _firestore
        .collection('messages')
        .orderBy("last_time", descending: true);
    final snapshot = await collectionRef.get();
    final documents = snapshot.docs.map((doc) {
      final documentData = doc.data();
      final documentId = doc.id;
      documentData['id'] = documentId;
      return documentData;
    }).toList();

    final filteredDocuments = documents.where((doc) {
      final docUser1Id = doc['user1_id'] as String;
      final docUser2Id = doc['user2_id'] as String;
      return docUser1Id == currentUserId || docUser2Id == currentUserId;
    }).toList();

    return filteredDocuments;
  }

  List<String> filterMessageUsers(Map<String, dynamic> doc) {
    List<String> messageUsers = [];

    if (doc['user1_id'] != currentUser!.uid) {
      messageUsers.add(doc['user1_name'] ?? '');
    } else {
      messageUsers.add(doc['user2_name'] ?? '');
    }

    return messageUsers;
  }

  List<String> filterUserDpUrl(Map<String, dynamic> data) {
    List<String> userDP = [];

    if (data['user1_id'] != currentUser!.uid) {
      userDP.add(data['user1DpUrl'] ?? '');
    } else {
      userDP.add(data['user2DpUrl'] ?? '');
    }

    return userDP;
  }

  List<String> filterUserId(Map<String, dynamic> data) {
    //Lists the ID of the people that are messaged
    List<String> userID = [];

    if (data['user1_id'] != currentUser!.uid) {
      userID.add(data['user1_id'] ?? '');
    } else {
      userID.add(data['user2_id'] ?? '');
    }

    return userID;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    _fetchAndFilterMessages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer.cancel();
    super.dispose();
  }

  void _handleTabChange() {
    if (_selectedIndex == 1) { // Check for "MESSAGES" tab index (usually 1)
      _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        _fetchAndFilterMessages();
      });
    } else {
      _refreshTimer.cancel(); // Cancel timer if not on "MESSAGES" tab
    }
  }

  @override
  Widget build(BuildContext context) {
    //_tabController.addListener(_handleTabChange);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                border: Border.all(width: 1, color: const Color.fromARGB(255, 229, 245, 227)),
                gradient: const LinearGradient(
                  colors: <Color>[
                    Color.fromARGB(255, 229, 245, 227),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [

                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        surfaceVariant: Colors.transparent,
                      )
                    ),
                    child: TabBar(
                      controller: _tabController,
                      tabs: [

                        //...................THREADS TAB HEADING.................//
                        Tab(
                          child: Container(
                            padding: _selectedIndex == 0 ? const EdgeInsets.all(5) : const EdgeInsets.all(0), 
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: primaryColor,
                            ),
                            child: _selectedIndex == 0 
                              ? Container(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3, color: Colors.white),
                                  borderRadius: BorderRadius.circular(45)
                                ),
                                child: const Center(
                                  child: Text(
                                    "Threads",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                    ),  
                                  ),
                                ),
                              ) 
                            : const Center(
                              child: Text(
                                "Threads",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                                ),  
                              ),
                            ),
                          )
                        ),
                    
                        //...................MESSAGES TAB HEADING.................//
                        Tab(
                          child: Container(
                            padding: _selectedIndex == 1 ? const EdgeInsets.all(5) : const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: primaryColor
                            ),
                            child: _selectedIndex == 1 
                            ? Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              decoration: BoxDecoration(
                                border: Border.all(width: 3, color: Colors.white),
                                borderRadius: BorderRadius.circular(45)
                              ),
                              child: const Center(
                                child: Text(
                                  "Messages",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white
                                  ),  
                                ),
                              ),
                            )
                            : const Center(
                              child: Text(
                                "Messages",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                                ),  
                              ),
                            ),
                          )
                        ),
                      ],
                      indicatorColor: Colors.transparent,
                    ),
                  ),

                  
                ],
              ),
            ),
          ),

          
          Container(
            padding: const EdgeInsets.only(
              top: 110,
              right: 40,
              left: 40,
              bottom: 40,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                
                //.............. Content for THREADS tab...............//
          
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('threads')
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
                          default:
                            final documents = snapshot.data!.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                final data = documents[index].data()! as Map<String, dynamic>;
                                DocumentSnapshot comment = documents[index];
                                String curDocID = comment.id;
                                String dp = data['dp-url'];
                                String authName = data['authorName'];
                                String title = data['title'];
                                String content = data['content'];
                                String latestReply = data['userLatestReply'];
                                String authID = data['authorID'];
                                String privacy = data['privacy'];
                                Timestamp createdAt = data['createdAt'] as Timestamp;
                                int votecount = data['voteCount'];
                                 
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AnswerPage(
                                          postID: curDocID,
                                          authorName: authName,
                                          authorID: authID,
                                          questionContent: content,
                                          questionTitle: title,
                                          privacyType: privacy,
                                          postTimestamp: createdAt,
                                          posterDP: dp,
                                          voteCount: votecount,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(width: 2, color: primaryColor),
                                      borderRadius: BorderRadius.circular(25) ,
                                    ),
                                    child: Column(
                                      children: [
                                  
                                        Row(
                                          children: [
                            
                                            CircleAvatar(                                     //......POSTER DP..........//
                                              foregroundColor: Colors.purple,
                                              radius:20,
                                              backgroundImage: NetworkImage(
                                                dp
                                              ),
                                            ),
                            
                                            SizedBox(width: MediaQuery.of(context).size.width * 0.02), 
                            
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                  
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.5,
                                                  child: Text(                              //........ NAME OF AUTHOR ........//
                                                      authName,
                                                      style: const TextStyle(
                                                        fontSize: 18.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                ),
                                                
                                                Text(                                       //.......ORIGINAL POST TIME........//
                                                  formatTimeDifference(
                                                    DateTime.now()
                                                        .difference(
                                                            (data['createdAt'] as Timestamp).toDate()
                                                      )
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily: primaryFont,
                                                    color: Colors.grey,
                                                    fontSize: 13
                                                  ),
                                                ),
                                              ],
                                            ),
                            
                                          ],
                                        ),
                            
                                        SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
                            
                                        Row(
                                          children: [
                                            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                                            
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.66,
                                              child: Text(  //.................... TITLE of original question ........//
                                                  title,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                            ),
                                          ],
                                        ),
                            
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                            
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                                                
                                                const Icon(Icons.subdirectory_arrow_right, size: 30, opticalSize: 70,),
                                                
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.35,
                                                  child: Text(  //.................... Reply of current User ........//
                                                    latestReply, 
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                
                                                const Text("(Me)", style: TextStyle(color: Colors.grey),),
                                              ],
                                            ),
                            
                                            Text(
                                              formatTimeDifference(
                                                DateTime.now()
                                                    .difference(
                                                        (data['userReplyTime'] as Timestamp).toDate()
                                                  )
                                              ),
                                              style: TextStyle(
                                                fontFamily: primaryFont,
                                                color: Colors.grey,
                                                fontSize: 13
                                              ),
                                            ),
                                          ],
                            
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                        }
                      },
                    ),
                  ),
                ),
                
                // Content for MESSAGES Tab
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(45.0),
                    border: Border.all(width: 2, color: primaryColor)
                  ),
                  child: filteredDocuments == null
                      ? const Center(child: Text('Loading messages...'))
                      : (filteredDocuments!.isEmpty)
                          ? const Center(
                              child: Text('No matching messages found.'))
                          : ListView.separated(
                              separatorBuilder: (context, index)
                                {return Divider(
                                  color: primaryColor,
                                  thickness: 2,
                                  indent: 25,
                                  endIndent: 25,
                                );},
                              itemCount: filteredDocuments!.length,
                              itemBuilder: (context, index) {
                                final doc = filteredDocuments![index];
                                //final listCount = filteredDocuments!.length;
                                //
                                //DateTime import and parsing
                                String formattedTimestamp = _formatTimestampForDisplay(doc['last_time']);
                                //
                                //
                                final messageUser = filterMessageUsers(doc);
                                final userDP = filterUserDpUrl(doc);
                                final userID = filterUserId(doc);
          
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          docID: doc['id'].toString(),
                                          userName: messageUser.first,
                                          userDP: userDP.first,
                                          userId: userID.first,
                                          currentUserId: currentUser!.uid,
                                        ),
                                      ),
                                    );
                                  },

                                  child: Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                                  
                                            Row(
                                              children: [
                                                Column( //...............RECIEVER DP..........//
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 25 ,
                                                      backgroundImage: NetworkImage(
                                                        userDP.isEmpty ? '$userDP' : userDP.join(' ')
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                
                                                SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                                                          
                                                Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        alignment:Alignment.centerLeft,
                                                        child: Text(
                                                          messageUser.isEmpty ? '$messageUser' : messageUser.join(' '),
                                                          style: const TextStyle(
                                                            fontWeight:FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                            
                                                      const Text("Student", style: TextStyle(fontSize: 12),),
                                        
                                                      SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                                                            
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.4,
                                                        alignment:Alignment.bottomLeft,
                                                        child: Text('${doc['last_msg'] ?? '(No Messages Yet)'}',
                                                          maxLines: 1,
                                                          overflow:TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            fontWeight:FontWeight.w400
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                                  
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  formattedTimestamp,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),

                                        if (index == (filteredDocuments!.length - 1)) const SizedBox(
                                          height: 10,
                                        ),

                                        if (index == (filteredDocuments!.length - 1)) Divider(
                                          color: primaryColor,
                                          thickness: 2,
                                          indent: 110,
                                          endIndent: 110,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
