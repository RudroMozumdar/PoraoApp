import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:porao_app/common/all_import.dart';

class MessagesThreads extends StatefulWidget {
  const MessagesThreads({super.key});

  @override
  State<MessagesThreads> createState() => _MessagesThreads();
}

class _MessagesThreads extends State<MessagesThreads>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController; // Declare as late

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>>? filteredDocuments; // Initialize as null

  var currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _fetchAndFilterMessages() async {
    filteredDocuments = await fetchAndFilterByUserId(currentUser!.uid);
    setState(() {}); // Trigger rebuild with updated data
  }

  String _formatTimestampForDisplay(dynamic timestampValue) {
    Timestamp firebaseTimestamp = timestampValue as Timestamp;
    DateTime dateTime = firebaseTimestamp.toDate();

    // Define the desired format pattern
    final formattedDate = DateFormat('h:mm a, d MMM, yyyy').format(dateTime);
    return formattedDate;
  }

  Future<List<Map<String, dynamic>>> fetchAndFilterByUserId(
    String currentUserId,
  ) async {
    final collectionRef = _firestore
        .collection('messages')
        .orderBy("last_time", descending: true);
    final snapshot = await collectionRef.get();
    final documents = snapshot.docs.map((doc) => doc.data()).toList();

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Call _fetchAndFilterMessages on initState
    _fetchAndFilterMessages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Child container with rounded corners and gradient
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 229, 245, 227),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // TabBar positioned on top
          Positioned(
            top: 40.0,
            left: 0.0,
            right: 0.0,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Threads'),
                Tab(text: 'Messages'),
              ],
            ),
          ),

          // Content relative to each tab bar
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 110,
                right: 40,
                left: 40,
                bottom: 20,
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Content for THREADS tab
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(45.0),
                        border: Border.all(width: 2, color: primaryColor)),
                    child: const Center(
                      child: Text('Threads Content'),
                    ),
                  ),

                  // Content for MESSAGES Tab
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(45.0),
                        border: Border.all(width: 2, color: primaryColor)),
                    child: filteredDocuments == null
                        ? const Center(child: Text('Loading messages...'))
                        : (filteredDocuments!.isEmpty)
                            ? const Center(
                                child: Text('No matching messages found.'))
                            : ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10.0),
                                itemCount: filteredDocuments!.length,
                                itemBuilder: (context, index) {
                                  final doc = filteredDocuments![index];
                                  //
                                  //DateTime import and parsing
                                  String formattedTimestamp =
                                      _formatTimestampForDisplay(
                                          doc['last_time']);
                                  //
                                  //
                                  final messageUser = filterMessageUsers(doc);
                                  final userDP = filterUserDpUrl(doc);
                                  return GestureDetector(
                                    // onTap: () {
                                    //   // Navigate to the next page with document data
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           const MyPosts(), // Replace with your page class
                                    //     ),
                                    //   );
                                    // },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 7,
                                        bottom: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(45.0),
                                        border: Border.all(
                                            width: 2, color: Colors.black),
                                      ),
                                      height: 80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            //Contains User DP
                                            width: 50,
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  userDP.isEmpty
                                                      ? '$userDP'
                                                      : userDP.join(' ')),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            //Contain Message info
                                            width: 150,
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    messageUser.isEmpty
                                                        ? '$messageUser'
                                                        : messageUser.join(' '),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 13,
                                                  child: Container(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Text(
                                                    '${doc['last_msg'] ?? '---'}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            //Contain Message last message time
                                            width: 50,
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  formattedTimestamp,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                )),
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
          ),
        ],
      ),
    );
  }
}
