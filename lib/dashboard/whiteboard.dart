import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:whiteboard/whiteboard.dart';
import 'package:porao_app/common/all_import.dart';

class WhiteboardWidget extends StatefulWidget {

  const WhiteboardWidget({Key? key,}) : super(key: key);

  @override
  _WhiteboardWidget createState() => _WhiteboardWidget();
}

class _WhiteboardWidget extends State<WhiteboardWidget> {

  WhiteBoardController whiteBoardController = WhiteBoardController();
  ScreenshotController screenshotController = ScreenshotController();
  String curUserID = FirebaseAuth.instance.currentUser!.uid;
  String curUserName = "#username";
  bool isStrokeSliderOpen = false;
  bool isColorSliderOpen = false;
  Color strokeColour = Colors.black;
  double stroke = 2;

  @override
  void initState() {
    super.initState();
    getUserName(curUserID);

  }

  Future getUserName(String curDocID) async {
    final docRef = FirebaseFirestore.instance.collection("users").doc(curUserID);
    final docSnapshot = await docRef.get();
    String firstName;

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data.containsKey('name')) {
        firstName = data['name'];
        firstName = firstName.split(" ").first;
        setState(() {
          curUserName = firstName;
        });
      }
    }
  }

  saveToGallery(BuildContext context) {
    screenshotController.capture().then((Uint8List? image) => {
      saveScreenshot(image!)
    });
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return const AlertDialog(
          backgroundColor: Color.fromARGB(206, 146, 190, 226),
          title: Center(child: Text('Image has been saved.')),
        );
      });
  }

  saveScreenshot(Uint8List bytes) async {
    final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');
    final name = 'Whiteboard$time';
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whiteboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('$curUserName\'s Whiteboard'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Stack(
            children: [
              Screenshot(
                controller: screenshotController,
                child: WhiteBoard(
                  controller: whiteBoardController,
                  strokeWidth: stroke,
                  strokeColor: strokeColour,
                )
              ),              
          
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(                             //..........FOR STROKE WIDTH
                    visible: isStrokeSliderOpen,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Set background color for the box
                        borderRadius: BorderRadius.circular(45),  
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Slider(
                              value: stroke,
                              divisions: 18,
                              min: 1,
                              max: 10, 
                              label: stroke.toString(),
                              onChanged: (double value){
                                setState(() {
                                  stroke = value;
                                });
                              },
                              onChangeEnd: (double value){
                                setState(() {
                                  isStrokeSliderOpen = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Visibility(                             //..........FOR STROKE COLOR
                    visible: isColorSliderOpen,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Set background color for the box
                        borderRadius: BorderRadius.circular(45),  
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              width: MediaQuery.of(context).size.width * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                strokeColour = Colors.white;
                                isColorSliderOpen = false;
                              });
                            },
                          ),

                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                strokeColour = Colors.purple;
                                isColorSliderOpen = false;
                              });
                            },
                          ),

                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                strokeColour = Colors.blue;
                                isColorSliderOpen = false;
                              });
                            },
                          ),

                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.cyan
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                strokeColour = Colors.cyan;
                                isColorSliderOpen = false;
                              });
                            },
                          ),

                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                strokeColour = Colors.green;
                                isColorSliderOpen = false;
                              });
                            },
                          ),

                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                strokeColour = Colors.yellow;
                                isColorSliderOpen = false;
                              });
                            },
                          ),

                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                strokeColour = Colors.orange;
                                isColorSliderOpen = false;
                              });
                            },
                          ),

                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                strokeColour = Colors.red;
                                isColorSliderOpen = false;
                              });
                            },
                          ),

                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              width: MediaQuery.of(context).size.width * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                strokeColour = Colors.black;
                                isColorSliderOpen = false;
                              });
                            },
                          ),

                        ],
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(45),
                      boxShadow:  [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 2.0,
                          spreadRadius: 2.0,
                          offset: const Offset(0.0, 3.0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    
                        Expanded(
                          child: Padding(                                          //.....Clear Button
                            padding: const EdgeInsets.all(10),
                            child: FloatingActionButton(
                              heroTag: "btn1",
                              onPressed: () {whiteBoardController.clear();}, 
                              child: const Icon(Icons.replay),
                            )
                          ),
                        ),
                    
                        Expanded(
                          child: Padding(                                         //......Undo Button
                            padding: const EdgeInsets.all(10),
                            child: FloatingActionButton(
                              heroTag: "btn2",
                              onPressed: () {whiteBoardController.undo();}, 
                              child: const Icon(Icons.undo),
                            )
                          ),
                        ),
                    
                        Expanded(
                          child: Padding(                                         //......Redo Button
                            padding: const EdgeInsets.all(10),
                            child: FloatingActionButton(
                              heroTag: "btn3",
                              onPressed: () {whiteBoardController.redo();}, 
                              child: const Icon(Icons.redo),
                            )
                          ),
                        ),
                    
                        Expanded(
                          child: Padding(                                         //......Stroke Button
                            padding: const EdgeInsets.all(10),
                            child: FloatingActionButton(
                              heroTag: "btn4",
                              onPressed: () {
                                setState(() {
                                  isStrokeSliderOpen = !isStrokeSliderOpen;
                                  isColorSliderOpen = false;
                                });
                              }, 
                              child: const Icon(Icons.brush),
                            )
                          ),
                        ),
                    
                        Expanded(                                         //......Colour Button
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: FloatingActionButton(
                              heroTag: "btn5",
                              onPressed: () {
                                setState(() {
                                  isColorSliderOpen = !isColorSliderOpen;
                                  isStrokeSliderOpen = false;
                                });
                              }, 
                              child: Icon(Icons.water_drop, color: strokeColour,),
                            ),
                          )
                        ),
                    
                        Expanded(                                         //......Save Button
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: FloatingActionButton(
                              heroTag: "btn6",
                              onPressed: () async {
                                saveToGallery(context);
                              }, 
                              child: const Icon(Icons.save),
                            ),
                          )
                        ),
                    
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}