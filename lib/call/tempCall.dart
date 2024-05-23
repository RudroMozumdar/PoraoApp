import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:porao_app/common/all_import.dart';
import 'package:porao_app/call/tempSignaling.dart';

class MyHomePage extends StatefulWidget {

  final String callerName;
  final String callerDP;
  final String calleeName;
  final String calleeDP;
  final String callerID;
  final String chatDocID;
  final String createOrJoin;
  final String roomID;

  const MyHomePage({
    Key? key,
    required this.callerName,
    required this.callerDP,
    required this.calleeName,
    required this.calleeDP,
    required this.callerID,
    required this.chatDocID,
    required this.createOrJoin,
    required this.roomID,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  bool cameraMicOn = false;
  bool roomCreatedVisible = true;
  bool roomJoinedVisible = true;

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    // signaling.openUserMedia(_localRenderer, _remoteRenderer);

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Room"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          ),
          
          
          Visibility(
            visible: roomJoinedVisible,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Enter Room ID")
                    ),
                    controller: textEditingController,
                  ),
                ),
            
                ElevatedButton(
                  onPressed: () {
                    signaling.joinRoom(
                      textEditingController.text.trim(),
                      _remoteRenderer,
                    );
                    setState(() {
                      roomJoinedVisible = !roomJoinedVisible;
                      roomCreatedVisible = !roomCreatedVisible;
                    });
                  },
                  child: Text("Join room"),
                ),              
              ],
            ),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: cameraMicOn  
                    ? const MaterialStatePropertyAll<Color>(Color.fromARGB(255, 245, 233, 248))
                    : const MaterialStatePropertyAll<Color>(Color.fromARGB(255, 237, 206, 241))
                ),
                onPressed: () {
                  signaling.openUserMedia(_localRenderer, _remoteRenderer);
                  setState(() {
                    cameraMicOn = !cameraMicOn;
                  });
                },
                //child: Text("Open camera & microphone"),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.video_call),

                      Text("/"),

                      Icon(Icons.mic)
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: roomCreatedVisible,
                child: ElevatedButton(
                  onPressed: () async {
                    roomId = await signaling.createRoom(_remoteRenderer);
                    sendRoomID();
                    setState(() {
                      roomCreatedVisible = !roomCreatedVisible;
                      roomJoinedVisible = !roomJoinedVisible;
                    });
                  },
                  child: Text("Create room"),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  signaling.hangUp(_localRenderer);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.call_end),    //........HANG UP
              )
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Future<void> sendRoomID() async {

    final roomRef = FirebaseFirestore.instance
      .collection('messages')
      .doc(widget.chatDocID)
      .collection('messagelist');

    var firstName = widget.callerName.split(" ").first;

    try {
      await roomRef.add({
        "addTime": Timestamp.now(),
        "content": "$firstName invited you to a Room. \nRoom ID: $roomId",
        "senderID": widget.callerID,
        "type": "text",
      });

      await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(widget.chatDocID)
        .update({
          'last_msg': "$firstName invited you to a Room. \nRoom ID: $roomId",
          'last_time': Timestamp.now(),
          'msg_num': FieldValue.increment(1),
        });
    } catch (error) {
      print('Error sending message: $error');
    }

  }
}