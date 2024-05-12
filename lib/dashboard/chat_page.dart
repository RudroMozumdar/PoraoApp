import 'package:intl/intl.dart';
import 'dart:io';
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
  bool showWhiteboard = false;
  Timer? _timer;
  File? _selectedImage;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //final AgoraClient

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

  String _formatTimestampForDisplay(dynamic timestampValue) {
    Timestamp firebaseTimestamp = timestampValue as Timestamp;
    DateTime dateTime = firebaseTimestamp.toDate();
    DateTime now = DateTime.now();

    // Calculate difference in days and years
    final int differenceInDays = now.difference(dateTime).inDays;
    final int differenceInYears = now.year - dateTime.year;

    // Define the desired format pattern based on difference
    String formattedDate;
    if (differenceInDays == 0) {
      // Today
      formattedDate = DateFormat('h:mm a').format(dateTime);
    } else if (differenceInDays == 1) {
      // Yesterday
      formattedDate = 'Yesterday, ${DateFormat('h:mm a').format(dateTime)}';
    } else if (differenceInDays < 7) {
      // Within a week, show weekday abbreviation
      formattedDate =
          '${DateFormat('EEE').format(dateTime)}, ${DateFormat('h:mm a').format(dateTime)}';
    } else if (differenceInYears == 0) {
      // Within the same year, but more than a week ago
      formattedDate =
          '${DateFormat('h:mm a').format(dateTime)}, ${DateFormat('d MMM').format(dateTime)}';
    } else {
      // Before the current year
      formattedDate = DateFormat('h:mm a, d MMM, yyyy').format(dateTime);
    }

    return formattedDate;
  }

  //text controller
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> messages = [];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(widget.userDP), //Reciever DP
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    "  ${widget.userName}", // Reciever NAME
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            IconButton(
              //.............CALL Button
              onPressed: () {},
              icon: const Icon(
                Icons.call,
                size: 30,
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(primaryButtonColor),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                )),
              ),
            ),
          ],
        ),
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMessageList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            messages = snapshot.data!;

            // _timer = Timer.periodic(
            //   const Duration(seconds: 2),
            //   (timer) => fetchMessageList().then(
            //     (data) {
            //       if (data != messages) {
            //         setState(
            //           () {
            //             messages = data;
            //           },
            //         );
            //       }
            //     },
            //   ),
            // );

            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      return _buildMessageBubble(message, widget.currentUserId);
                    },
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
    final bool isSender = message['senderID'] ==
        currentUserId; // whether the current user is sender or not
    final Color messageColor = isSender ? primaryColor : Colors.green;
    final MainAxisAlignment mainAxisAlignment =
        isSender ? MainAxisAlignment.end : MainAxisAlignment.start;
    const TextAlign textAlign = TextAlign.left;
    String messageTime = _formatTimestampForDisplay(message['addTime']);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender)
            const SizedBox(width: 10), // Add some space for non-sender messages

          if (isSender)
            Text(messageTime,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12)), //Place Message time to LEFT of BOX

          Container(
            margin: isSender
                ? const EdgeInsets.only(left: 5)
                : const EdgeInsets.only(right: 5),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
              minWidth: MediaQuery.of(context).size.width * 0.1,
            ),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: messageColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              message['content'] ?? ' ',
              textAlign: textAlign,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          if (!isSender)
            Text(messageTime,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12)), //Place Message time to RIGHT of BOX

          if (isSender)
            const SizedBox(width: 10), // Add some space for sender messages
        ],
      ),
    );
  }

  // making user input textfield
  Widget _buildUserInput() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          IconButton(       //.............Keyboard ATTACHMENT Button
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WhiteboardWidget(),
                ),
              );
            }, 
            icon: const Icon(Icons.attach_file_outlined, size: 30,),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(primaryButtonColor),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                )
              ),
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: primaryButtonColor,
                      borderRadius: BorderRadius.circular(45)),
                  padding: const EdgeInsets.only(left: 15, right: 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type Message here',
                              filled: true,
                              fillColor: primaryButtonColor,
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(45),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            controller: _messageController,
                            autofocus: true,
                            onSubmitted: (text) {
                              print("Reply: $text");
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: IconButton(
                            onPressed: () async {
                              final messageContent = _messageController.text;

                              final messageId =
                                  _firestore.collection('messagelist').doc().id;

                              try {
                                await _firestore
                                    .collection('messages')
                                    .doc(widget
                                        .docID) // Use the existing chat document ID
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

                                setState(
                                    () {}); // Refresh the UI to reflect the new message
                              } catch (error) {
                                // Handle any errors that occur during Firestore operations
                                print('Error sending message: $error');
                              }
                            },
                            icon: const Icon(Icons.send),
                          ),
                        )
                      ])))
        ],
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      // Permission granted, proceed with picking the image
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage != null) {
        setState(() {
          _selectedImage = File(returnedImage.path);
        });
      }
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied, handle it
      openAppSettings(); // Open app settings to allow permissions
    } else {
      print('Didnt work');
    }
  }
}

