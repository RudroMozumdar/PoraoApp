import 'package:flutter/material.dart';
import 'package:whiteboard/whiteboard.dart';

class Whiteboard extends StatefulWidget {

  const Whiteboard ({Key? key}) : super(key: key);

  @override
  State<Whiteboard> createState() => _Whiteboard();
}

class _Whiteboard extends State<Whiteboard> {

  final WhiteBoardController _controller = WhiteBoardController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whiteboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Whiteboard'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: WhiteBoard(
                  controller: _controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}