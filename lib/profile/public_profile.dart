import 'dart:math';

import 'package:porao_app/common/all_import.dart';

class PublicProfile extends StatefulWidget {
  const PublicProfile({super.key});

  @override
  State<PublicProfile> createState() => _PublicProfileState();
}

class _PublicProfileState extends State<PublicProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rudro Mozumdar',
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
            currentTab = 0;
            pageController.animateToPage(
              currentTab,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastEaseInToSlowEaseOut,
            );
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
            review(),
            deviderWithShadow(),
            experties(),
          ],
        ),
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
            const Image(
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/rudro.jpg'),
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
            // -------------------------------------------------------- Message
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: const EdgeInsets.only(top: 135, right: 5),
                  child: GestureDetector(
                    child: Container(
                      height: 40,
                      width: 120,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.message_rounded, color: Colors.white),
                          Text(
                            " MESSAGE",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  )),
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
            'Rudro Mozumdar',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontFamily: primaryFont,
              fontSize: 25,
            ),
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
          // -----------------------------------------------------Review
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

  Widget experties() {
    return const Placeholder();
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
          color: Colors.black,
        ),
      ],
    );
  }
}
