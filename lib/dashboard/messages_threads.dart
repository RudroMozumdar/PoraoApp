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

  Future<void> _fetchAndFilterMessages() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    filteredDocuments = await fetchAndFilterByUserId(currentUser!.uid);
    setState(() {}); // Trigger rebuild with updated data
  }

  Future<List<Map<String, dynamic>>> fetchAndFilterByUserId(
    String currentUserId,
  ) async {
    final collectionRef = _firestore.collection('messages');
    final snapshot = await collectionRef.get();
    final documents = snapshot.docs.map((doc) => doc.data()).toList();

    final filteredDocuments = documents.where((doc) {
      final docUser1Id = doc['user1_id'] as String; // Cast to String
      final docUser2Id = doc['user2_id'] as String; // Cast to String
      return docUser1Id == currentUserId || docUser2Id == currentUserId;
    }).toList();

    return filteredDocuments;
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
                            : ListView.builder(
                                itemCount: filteredDocuments!.length,
                                itemBuilder: (context, index) {
                                  final doc = filteredDocuments![index];
                                  return Text(
                                    'User ID: ${doc['user1_id'] ?? '---'} OR ${doc['user2_id'] ?? '---'}',
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
