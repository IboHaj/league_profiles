import 'package:flutter/material.dart';

class ExperimentWidget extends StatefulWidget {
  @override
  _ExperimentWidgetState createState() => _ExperimentWidgetState();
}

class _ExperimentWidgetState extends State<ExperimentWidget> {
  @override
  Widget build(BuildContext context) {
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
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'images/objectives_icons/map12.png'))),
                    alignment:
                        Alignment((5660 - 7435) / 7435, -(6237 - 7490) / 7490),
                    child: Text(
                      '.',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
