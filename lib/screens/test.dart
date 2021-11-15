import 'package:flutter/material.dart';

class ExperimentWidget extends StatefulWidget {
  @override
  _ExperimentWidgetState createState() => _ExperimentWidgetState();
}

class _ExperimentWidgetState extends State<ExperimentWidget> {
  @override
  Widget build(BuildContext context) {
    print(((8282 - 7435) / 7435));
    print(((8096 - 7490) / 7490));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                                'images/objectives_icons/map11.png'))),
                    alignment: Alignment(
                        ((2988 - 7435) / 7435), (-(12628 - 7490) / 7490)),
                    // child: Text(
                    //   '.',
                    //   style: TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.red),
                    // ),
                    child: SizedBox(
                      child: Image(
                        image: AssetImage('images/champion_icons/LeeSin.png'),
                      ),
                      height: 10,
                      width: 10,
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
