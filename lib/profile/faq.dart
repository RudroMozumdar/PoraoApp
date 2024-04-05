import 'package:porao_app/common/all_import.dart';
//import 'package:flutter/material.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  final List<Item> _data = List<Item>.generate(10, (int index) {
    return Item(
        headerText: 'Question $index',
        expandedText: 'This is item number $index');
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "FAQ"),
        body: Container(
          height: 1200,
          width: 500,
          color: Colors.white,
          child: SingleChildScrollView(
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _data[index].isExpanded = !isExpanded;
                });
              },
              children: _data.map<ExpansionPanel>((Item item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(item.headerText),
                    );
                  },
                  body: ListTile(
                      title: Text(item.expandedText),
                      subtitle:
                          const Text('to delete this item, click trash icon'),
                      trailing: const Icon(
                        Icons.delete,
                        color: Colors.amberAccent,
                      ),
                      onTap: () {
                        setState(() {
                          _data.removeWhere(
                              (Item currentItem) => item == currentItem);
                        });
                      }),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ),
        ));
  }
}

class Item {
  Item({
    required this.headerText,
    required this.expandedText,
    this.isExpanded = false,
  });

  String headerText;
  String expandedText;
  bool isExpanded;
}
