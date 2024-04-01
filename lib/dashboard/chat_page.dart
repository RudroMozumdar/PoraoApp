import 'package:porao_app/common/all_import.dart';

class ChatPage extends StatefulWidget {
  final String docID;
  final String userName;
  final String userId;
  final String userDP;
  final String currentUserId;

  const ChatPage({
    Key? key,
    required this.docID,
    required this.userName,
    required this.userId,
    required this.userDP,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchMessageList() async {
    final collectionRef = _firestore
        .collection('messages')
        .doc(widget.docID)
        .collection('messagelist')
        .orderBy("addTime", descending: true);
    final snapshot = await collectionRef.get();
    final documents = snapshot.docs.map((doc) {
      final documentData = doc.data();
      return documentData;
    }).toList();

    return documents;
  }

  //text controller
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> messages = [];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(widget.userDP),
            ),
            Text(
              "  ${widget.userName}",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: primaryColor,
      ),
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMessageList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            messages = snapshot.data!;

            Timer.periodic(
              const Duration(seconds: 2),
              (timer) => fetchMessageList().then(
                (data) {
                  if (data != messages) {
                    setState(
                      () {
                        messages = data;
                      },
                    );
                  }
                },
              ),
            );

            return Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        return _buildMessageBubble(
                            message, widget.currentUserId);
                      },
                    ),
                  ),
                ),
                _buildUserInput(),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching messages');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildMessageBubble(
      Map<String, dynamic> message, String currentUserId) {
    final bool isSender = message['senderID'] == currentUserId;
    final Color messageColor = isSender ? Colors.cyan : Colors.lightGreen;
    final MainAxisAlignment mainAxisAlignment =
        isSender ? MainAxisAlignment.end : MainAxisAlignment.start;
    final TextAlign textAlign = isSender ? TextAlign.right : TextAlign.left;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (!isSender)
            const SizedBox(width: 10), // Add some space for non-sender messages
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: messageColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              message['content'] ?? ' ',
              textAlign: textAlign,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          if (isSender)
            const SizedBox(width: 10), // Add some space for sender messages
        ],
      ),
    );
  }

  // making user input textfield
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Adjust padding as needed
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 5),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                final messageContent = _messageController.text;

                final messageId = _firestore.collection('messagelist').doc().id;

                try {
                  await _firestore
                      .collection('messages')
                      .doc(widget.docID) // Use the existing chat document ID
                      .collection('messagelist')
                      .doc(messageId)
                      .set({
                    'content': messageContent,
                    'addTime': FieldValue
                        .serverTimestamp(), // Add a timestamp for message order
                    'senderID': widget.currentUserId,
                    'type': "text"
                  });

                  _messageController.clear();

                  try {
                    await _firestore
                        .collection('messages')
                        .doc(widget.docID)
                        .update({
                      'last_msg': messageContent,
                      'last_time': FieldValue
                          .serverTimestamp(), // Add a timestamp for message order
                      'msg_num': FieldValue.increment(1),
                    });
                  } catch (error) {
                    print('Error sending message: $error');
                  }

                  setState(() {}); // Refresh the UI to reflect the new message
                } catch (error) {
                  // Handle any errors that occur during Firestore operations
                  print('Error sending message: $error');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
