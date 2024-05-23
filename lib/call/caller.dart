import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:porao_app/common/all_import.dart';
import 'package:porao_app/call/signaling.dart';

class CallerWidget extends StatefulWidget {

  final String callerName;
  final String callerDP;
  final String calleeName;
  final String calleeDP;
  final String callerID;
  final String chatDocID;
  final String createOrJoin;
  final String roomID;

  const CallerWidget({
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
  _CallerWidget createState() => _CallerWidget();
}

class _CallerWidget extends State<CallerWidget> {

  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    //signaling.openUserMedia(_localRenderer, _remoteRenderer);

    if(widget.createOrJoin == "Create"){
      createRoomWithAsync();
    } else if (widget.createOrJoin == "Join"){
      joinRoomwithoutAsync();
    }
    
    super.initState();
  }

  Future<void> createRoomWithAsync () async {
    roomId = await signaling.createRoom(_remoteRenderer);
    textEditingController.text = roomId!;
    sendRoomID();
    setState(() {});
  }

  void joinRoomwithoutAsync() {
    signaling.joinRoom(
      widget.roomID,
      _remoteRenderer,
    );
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
      appBar: AppBar(
        title: Text(widget.roomID),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  signaling.openUserMedia(_localRenderer, _remoteRenderer);
                },
                child: Text("Open camera & microphone"),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () async {
                  roomId = await signaling.createRoom(_remoteRenderer);
                  textEditingController.text = roomId!;
                  setState(() {});
                },
                child: Text("Create room"),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  // Add roomId
                  signaling.joinRoom(
                    textEditingController.text.trim(),
                    _remoteRenderer,
                  );
                },
                child: Text("Join room"),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  signaling.hangUp(_localRenderer);
                },
                child: Text("Hangup"),
              )
            ],
          ),
          SizedBox(height: 8),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8)
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
