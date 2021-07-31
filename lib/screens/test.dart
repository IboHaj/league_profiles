import 'package:flutter/material.dart';

class ExperimentWidget extends StatefulWidget {
  @override
  _ExperimentWidgetState createState() => _ExperimentWidgetState();
}

class _ExperimentWidgetState extends State<ExperimentWidget> {
  @override
  Widget build(BuildContext context) {
    bool expanded = false;
    var listItems = <ExpansionPanel>[];
    listItems.add(ExpansionPanel(
        canTapOnHeader: true,
        headerBuilder: (BuildContext context, expanded) {
          return ListTile(
            title: Text('Event details go here'),
          );
        },
        body: SizedBox(
          height: 200,
          width: 200,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/objectives_icons/map11.png'))),
            alignment: Alignment(0 / 7435, -3500 / 7490),
            child: Text(
              '.',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        isExpanded: false));
    return MaterialApp(
      title: "THINGSZ",
      home: Scaffold(
        appBar: AppBar(
          title: Text('THINGSZ'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: ExpansionPanelList(
                  expansionCallback: (index, isExpanded) {
                    setState(() {
                      print(index);
                      print(isExpanded);
                      print(listItems[index].isExpanded);
                      listItems[index].isExpanded = !isExpanded;
                    });
                  },
                  children: listItems,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
