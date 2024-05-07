import 'package:flutter/material.dart';
import 'package:porao_app/common/all_import.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Personal Details'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
}
