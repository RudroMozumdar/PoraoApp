import 'package:porao_app/common/all_import.dart';

class CallScreen extends StatelessWidget {
  final String name;
  final String DP;

  const CallScreen({
    Key? key,
    required this.name,
    required this.DP,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text("Calling \n" + name, textAlign: TextAlign.center,)),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200], // Set background color for the circle
              ),
              child: ClipOval( // Clip content to fit within the circle
                child: Image.network(
                  // Replace with your image URL
                  DP,
                  fit: BoxFit.cover, // Adjust image fitting if needed
                ),
              ),
            ),
          ),

          AlertDialog(
            backgroundColor: Color.fromARGB(206, 146, 190, 226),
            title: Center(child: Text('[ERROR] CALL FAILED (x1298j08_no_balance)\nYour Current Minutes Balance: 0 mins.')),
            actions: [
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, 
              icon: Center(child: Text("Go Back")))
            ],
          ),
          // Positioned row for buttons at bottom center
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.video_camera_back),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Icon(Icons.add_ic_call, color: Colors.green),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {}, // Replace with actual joining logic
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  child: Icon(Icons.call, color: Colors.white),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Icon(Icons.call, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
