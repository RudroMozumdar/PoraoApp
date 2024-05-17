import 'package:porao_app/common/all_import.dart';

class PublicProfile extends StatefulWidget {
  final String uid;
  const PublicProfile({
    super.key,
    required this.uid,
  });

  @override
  State<PublicProfile> createState() => _PublicProfileState();
}

class _PublicProfileState extends State<PublicProfile> {
  String name = "";
  String designation = "";
  String institution = "";
  String location = "";
  double rating = 0.0;
  int conversation = 0;
  String dpurl = "";
  String coverurl = "";
  String aboutContent = "";
  List<String> hashtags = [];
  List<dynamic> qualificationsList = [];
  List<dynamic> reviews = [];
  Color bgColor = Colors.white;
  Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').get(),
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
        int userIndex = snapshot.data!.docs
            .indexWhere((element) => element.id == widget.uid);
        final userData = snapshot.data?.docs[userIndex].data();

        name = userData!['name'];
        designation = userData['designation'];
        institution = userData['institution-name'];
        location = userData['location'];
        rating = userData['rating']?.toDouble();
        conversation = userData['conversations']?.toInt();
        dpurl = userData['dp-url'];
        coverurl = userData['cover-url'];
        aboutContent = userData['about'];
        hashtags = userData['hashtags'].cast<String>();
        qualificationsList = userData['qualifications'].cast<dynamic>();
        reviews = userData['qualifications'].cast<dynamic>();

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: Text(
              name,
              style: TextStyle(
                fontFamily: primaryFont,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: primaryColor,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                coverAndDP(),
                names(),
                actions(),
                deviderWithShadow(),
                about(),
                deviderWithShadow(),
                qualifications(),
                hashTagsChips(),
                deviderWithShadow(),
                stats(),
                deviderWithShadow(),
                review(),
                deviderWithShadow(),
                experties(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget coverAndDP() {
    return Column(
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
            Center(
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 80, left: 30),
                child: Stack(
                  children: [
                    // ------------------------------------Display Picture
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipOval(
                        child: Image(
                          height: 90,
                          width: 90,
                          image: NetworkImage(dpurl),
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
                          color: bgColor,
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
            ),
          ],
        ),
      ],
    );
  }

  Widget names() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: textColor,
                fontFamily: primaryFont,
                fontSize: 25,
              ),
            ),
            Text(
              '$designation at $institution',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: textColor,
                fontFamily: primaryFont,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              institution,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: textColor,
                fontFamily: primaryFont,
                fontSize: 13,
              ),
            ),
            Text(
              location,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: primaryFont,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.facebook),
          color: Colors.green,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.whatsapp),
          color: Colors.green,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.linkedin),
          color: Colors.green,
        ),
        // ---------------------------------------------------- Write a review
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            child: Container(
              height: 35,
              width: 130,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.reviews,
                    color: textColor,
                    size: 20,
                  ),
                  Text(
                    " Give a Review",
                    style: TextStyle(color: textColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            onTap: () async {
              showReviewDialog(context);
            },
          ),
        ),
        // ----------------------------------------------Message
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            child: Container(
              height: 35,
              width: 110,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message_rounded,
                    color: textColor,
                    size: 20,
                  ),
                  Text(
                    " MESSAGE",
                    style: TextStyle(color: textColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            onTap: () async {},
          ),
        ),
      ],
    );
  }

  Widget about() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              color: textColor,
              fontFamily: primaryFont,
              fontSize: 20,
            ),
          ),
          ExpandableText(
            aboutContent,
            expandText: 'show more.',
            maxLines: 3,
            linkColor: Colors.blue,
            animation: true,
            collapseText: '...show less',
            expandOnTextTap: true,
            collapseOnTextTap: true,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: textColor,
              fontFamily: primaryFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget hashTagsChips() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: hashtags.map((hashtag) => chipForHashtag(hashtag)).toList(),
      ),
    );
  }

  Widget chipForHashtag(String hashtag) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Chip(
        labelPadding: const EdgeInsets.all(0),
        avatar: const Icon(
          Icons.tag_rounded,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        label: Text(
          hashtag,
          style: TextStyle(
            fontFamily: primaryFont,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 166, 230, 255),
      ),
    );
  }

  Widget qualifications() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: qualificationsList
            .map(
                (quals) => qualificationItems(quals['icon-tag'], quals['text']))
            .toList(),
      ),
    );
  }

  Widget qualificationItems(String iconTag, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            Icon(
              iconTag == 'study' ? Icons.menu_book_sharp : Icons.work,
              color: textColor,
            ),
            const SizedBox(width: 7),
            Text(
              text,
              style: TextStyle(
                fontFamily: primaryFont,
                color: textColor,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget stats() {
    double h = 80;
    double w = 100;
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: h,
                width: w,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '21',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: primaryFont,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      'Answers',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: primaryFont,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: h,
                width: w,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '5',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: primaryFont,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      'Questions',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: primaryFont,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: h,
                width: w,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$conversation',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: primaryFont,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      'Conversations',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: primaryFont,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: h,
                width: w,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$rating',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: primaryFont,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      'Rating',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: primaryFont,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget review() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top Reviews',
                style: TextStyle(
                  fontFamily: primaryFont,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              // ---------------heading
              Row(
                children: [
                  const ClipOval(
                    child: Image(
                      image: AssetImage('assets/images/rudro.jpg'),
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontFamily: primaryFont,
                          color: textColor,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Occupation',
                        style: TextStyle(
                          fontFamily: primaryFont,
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.star, size: 18, color: primaryColor),
                  Icon(Icons.star, size: 18, color: primaryColor),
                  Icon(Icons.star, size: 18, color: primaryColor),
                  Icon(Icons.star_half, size: 18, color: primaryColor),
                  Icon(Icons.star_border, size: 18, color: primaryColor),
                  const SizedBox(width: 8),
                ],
              ),
              // --------------------Review Text
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ExpandableText(
                  'I would have loved this dress if the bust and waist were just a little more fitted. i am 32c and the top was too big. fit perfectly on hips. the lace material means it cannot be easily altered, so i chose to return the dress. i would have definitely kept it if it were a better fit.',
                  expandText: 'show more.',
                  maxLines: 2,
                  linkColor: primaryColor,
                  animation: true,
                  collapseText: '...show less',
                  expandOnTextTap: true,
                  collapseOnTextTap: true,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: primaryFont,
                    color: textColor,
                    fontSize: 13,
                  ),
                ),
              ),
              // ------------------More Review
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Image(
                  image: AssetImage('assets/images/icons/more.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget experties() {
    return Container();
  }

  Widget deviderWithShadow() {
    return Column(
      children: [
        // Container(
        //   height: 3,
        //   width: double.infinity,
        //   color: Colors.grey[800],
        // ),
        Container(
          height: 5,
          width: double.infinity,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  void showReviewDialog(BuildContext context) {
    double userRating = 0.0;
    final TextEditingController reviewController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: primaryColor,
          title: Text(
            'Write a Review',
            style: TextStyle(
              fontFamily: primaryFont,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: userRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    userRating = rating;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontFamily: primaryFont,
                    color: Colors.black,
                  ),
                  hintText: 'Write your review here...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                String reviewerUID = Auth().currentUser!.uid;
                final reviewText = reviewController.text;
                print('Rating: $userRating, Review: $reviewText $reviewerUID');
                Navigator.pop(context);
              },
              child: const Text('SUBMIT'),
            ),
          ],
        );
      },
    );
  }

  void messageBuilder() async {
    final String curUserId = FirebaseAuth.instance.currentUser!.uid;

    final List<String> userIds = [curUserId, widget.uid];

    final Stream<QuerySnapshot> existingMessages = FirebaseFirestore.instance
        .collection('messages')
        .where('user1id', whereIn: userIds)
        .where('user2id', whereIn: userIds)
        .snapshots();

    // await for (final snapshot in existingMessages) {
    //   if (snapshot.docs.isNotEmpty) {
    //     // Existing message found, process data
    //     final messageData = snapshot.docs.first.data();
    //     final String docID = snapshot.docs.first.id; // Get document ID

    //     // Determine user information based on current user ID
    //     final String userName = messageData?.['user1_id'] == curUserId
    //       ? messageData?.['user2_name']
    //       : messageData?.['user1_name'];
    //   final String userDP = messageData?.['user1_id'] == curUserId
    //       ? messageData?.['user2DpUrl']
    //       : messageData?.['user1DpUrl'];
    //   final String userId = messageData?.['user1_id'] == curUserId
    //       ? messageData?.['user2_id']
    //       : messageData?.['user1_id'];

    //     // Push to ChatPage with retrieved data
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => ChatPage(
    //           docID: docID,
    //           userName: userName,
    //           userDP: userDP,
    //           userId: userId,
    //           currentUserId: curUserId,
    //         ),
    //       ),
    //     );
    //     return; // Exit the loop after processing the first message (assuming only one match)
    //   }
    // }

    // No existing message found, create a new document
    final sender =
        FirebaseFirestore.instance.collection('user').doc(curUserId).get();
    final senderData = (await sender).data();

    final senderName = senderData!['name']; // Use null-assertion after await
    final senderDP = senderData['DP'];

    final receiver =
        FirebaseFirestore.instance.collection('user').doc(widget.uid).get();
    final receiverData = (await receiver).data();

    final receiverName = receiverData!['name'];
    final receiverDP = receiverData['DP'];

    final docRef = FirebaseFirestore.instance.collection('messages').doc();
    await docRef.set({
      'user1_id': curUserId,
      'user2_id': widget.uid,
      'user1_name': senderName,
      'user2_name': receiverName,
      'user1DpUrl': senderDP,
      'user2DpUrl': receiverDP,
      'msg_num': 0,
    });
  }
}
