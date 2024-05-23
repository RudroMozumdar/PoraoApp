import 'package:porao_app/common/all_import.dart';

class PersonalDetails extends StatefulWidget {

  final String profileID;

  const PersonalDetails({
    Key? key,
    required this.profileID,
  }) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  String name = "";
  String location = "Not-Provided";
  String qualification = "";
  double rating = 0.0;
  int conversation = 0;
  String dpurl = "";
  String coverurl = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileID);
    final docSnapshot = await userRef.get();
    if (docSnapshot.exists) {
      final userData = docSnapshot.data();
      final qualif = userData?['qualifications'];
      final userQualification = qualif.last;
      setState(() {
        name = userData?['name'];
        qualification = userQualification;
        dpurl = userData?['dp-url'];
        coverurl = userData?['dp-url'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.profileID),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------------------------Images
          Stack(
            children: [
              // --------------------------------------------------------Cover
              Image(
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(coverurl),
              ),
              // -----------------------------------------------Display Picture Section
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 80, left: 30),
                child: Stack(
                  children: [
                    // ------------------------------------Display Picture
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const ClipOval(
                        child: Image(
                          height: 90,
                          width: 90,
                          image: AssetImage('assets/images/rudro.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // -------------------------------------------------Add Icon (Change DP)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Show Pulic Profile-----------------------------------------------------------
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 135, right: 5),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 170,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: primaryColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 5,
                              right: 5,
                              bottom: 5,
                            ),
                            child: Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                          Text(
                            "Show Public Profile",
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontFamily: primaryFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // -----------------------------------------------------Names
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rudro Mozumdar',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: primaryFont,
                        fontSize: 25,
                      ),
                    ),
                    GestureDetector(            //.....................MESSAGE BUTTON
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.message_rounded, color: Colors.white),
                            Text(
                              " MESSAGE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        messageBuilder();
                      },
                    )
                  ],
                ),
                Text(
                  'Student of North South University',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: primaryFont,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'North South University',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: primaryFont,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Dhala, Bangladesh',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: primaryFont,
                    fontSize: 13,
                  ),
                ),
                // -----------------------------------------------------Reviews
                Row(
                  children: [
                    Text(
                      '4.7 ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: primaryFont,
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      size: 13,
                      color: primaryColor,
                    ),
                    Container(
                      height: 3,
                      width: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: primaryButtonColor,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    Text(
                      '10 Conversation Started',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: primaryFont,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // -------------------------------------------------Actions
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // send msg here
                  },
                  icon: Icon(
                    Icons.message,
                    color: primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.heart_broken),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.heart_broken),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> messageBuilder() async {
    final String curUserId = "87zvzezdC4dNSVFpDkKNhjqlB6u2";//FirebaseAuth.instance.currentUser!.uid;

    final List<String> userIds = [curUserId, widget.profileID];

    final existingMessages = FirebaseFirestore.instance
        .collection('messages')
        .where('user1id', whereIn: userIds)
        .where('user2id', whereIn: userIds);

    final snapshot = await existingMessages.get();
    final documents = snapshot.docs.map((doc) {
      final documentData = doc.data();
      final documentId = doc.id;
      documentData['id'] = documentId;
      return documentData;
    }).toList();


    if (documents.isNotEmpty){
      final Map<String, dynamic> doc = documents[0];
      String docID = "";
      String userName = "";
      String userDP = "";
      String userId = "";

      if (doc['user1_id'] == curUserId) {
        docID = doc['id'];
        userName = doc['user2_name'];
        userDP = doc['user2DpUrl'];
        userId = doc['user2_id'];
      } else if (doc['user2_id'] == curUserId) {
        docID = doc['id'];
        userName = doc['user1_name'];
        userDP = doc['user1DpUrl'];
        userId = doc['user1_id'];
      } 
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              docID: docID,
              userName: userName,
              userDP: userDP,
              userId: userId,
              currentUserId: curUserId,
            ),
          ),
        );
    }
    // Push to ChatPage with retrieved data
    

    // No existing message found, create a new document
    if (widget.profileID != curUserId) {
      final sender = FirebaseFirestore.instance.collection('user').doc(curUserId).get();
      final senderData = (await sender).data();
      
      final senderName = senderData!['name']; // Use null-assertion after await
      final senderDP = senderData['DP'];
      
      final receiver = FirebaseFirestore.instance.collection('user').doc(widget.profileID).get();
      final receiverData = (await receiver).data();
      
      final receiverName = receiverData!['name'];
      final receiverDP = receiverData['DP'];
      
      final docRef = FirebaseFirestore.instance.collection('messages').doc();
      await docRef.set({
        'user1_id': curUserId,
        'user2_id': widget.profileID,
        'user1_name': senderName,
        'user2_name': receiverName,
        'user1DpUrl': senderDP,
        'user2DpUrl': receiverDP,
        'last_msg': "",
        'last_time': Timestamp.now(),
        'msg_num': 0,
      });
    }
  }

}
