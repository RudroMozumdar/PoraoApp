import 'package:porao_app/common/all_import.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  String name = "";
  String designation = "";
  String institution = "";
  String location = "";
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
        .doc('rNc4Xg5B4CbjBaJzCzUoySNAqxF2');
    final docSnapshot = await userRef.get();
    if (docSnapshot.exists) {
      final userData = docSnapshot.data();
      setState(() {
        name = userData?['name'];
        designation = userData?['designation'];
        institution = userData?['institution-name'];
        location = userData?['location'];
        rating = userData?['rating']?.toDouble();
        conversation = userData?['conversations']?.toInt();
        dpurl = userData?['dp-url'];
        coverurl = userData?['cover-url'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Personal Details'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          coverAndDP(),
          names(),
          actions(),
          deviderWithShadow(),
          review(),
          deviderWithShadow(),
        ],
      ),
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
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const PublicProfile();
                    }));
                  },
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
      ],
    );
  }

  Widget names() {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontFamily: primaryFont,
              fontSize: 25,
            ),
          ),
          Text(
            designation,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontFamily: primaryFont,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            institution,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
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
          // -----------------------------------------------------Review
          Row(
            children: [
              Text(
                "$rating ",
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
                '$conversation Conversation Started',
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
    );
  }

  Widget actions() {
    return Container(
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
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // ---------------heading
              Row(
                children: [
                  ClipOval(
                    child: Image(
                      image: NetworkImage(dpurl),
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
                          color: Colors.white,
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
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              // ------------------More Reviiew
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
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

  Widget deviderWithShadow() {
    return Column(
      children: [
        Container(
          height: 3,
          width: double.infinity,
          color: Colors.grey[800],
        ),
        Container(
          height: 5,
          width: double.infinity,
          color: Colors.grey[700],
        ),
      ],
    );
  }

  // void messageCreater(BuildContext context, String profileUserId) async {

  //   final String curUserId = FirebaseAuth.instance.currentUser!.uid;

  //   final List<String> userIds = [curUserId, profileUserId];

  //   final Stream<QuerySnapshot> existingMessages = FirebaseFirestore.instance
  //       .collection('messages')
  //       .where('user1id', whereIn: userIds)
  //       .where('user2id', whereIn: userIds)
  //       .snapshots();

  //   await for (final snapshot in existingMessages) {
  //     if (snapshot.docs.isNotEmpty) {
  //       final messageData = snapshot.docs.first.data();
  //       return;
  //     }
  //   }

  //   final docRef = FirebaseFirestore.instance.collection('messages').doc();
  //   await docRef.set({
  //     'user1id': curUserId,
  //     'user2id': profileUserId,
  //   });

  // }
}
