import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:league_logger/screens/match_history.dart';
import 'package:provider/provider.dart';
import 'package:league_logger/constants.dart';

class SummonerProfile extends StatefulWidget {
  final Map<String, dynamic> summonerInfo;
  final summonerMasteryInfo;
  final summonerRankInfo;
  SummonerProfile(
      this.summonerInfo, this.summonerRankInfo, this.summonerMasteryInfo);

  @override
  _SummonerProfileState createState() => _SummonerProfileState(
      this.summonerInfo, this.summonerRankInfo, this.summonerMasteryInfo);
}

class _SummonerProfileState extends State<SummonerProfile> {
  final Map<String, dynamic> summonerInfo;
  final summonerMasteryInfo;
  final summonerRankInfo;
  _SummonerProfileState(
      this.summonerInfo, this.summonerRankInfo, this.summonerMasteryInfo);
  @override
  Widget build(BuildContext context) {
    print(Provider.of<Version>(context, listen: false).version);
    return MaterialApp(
      theme: kAppTheme,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left_outlined),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            padding: EdgeInsets.only(right: 40),
          ),
          centerTitle: true,
          actions: [
            Container(
              child: Row(
                children: [
                  TextButton(
                      child: Text(
                        'Matches',
                        style: TextStyle(
                            fontFamily: "Friz Quadrata",
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      onPressed: () async {
                        bool result =
                            await InternetConnectionChecker().hasConnection;
                        if (result == false) {
                          showAlertDialog(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MatchHistory(summonerInfo)));
                        }
                      }),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right_outlined),
                    onPressed: () async {
                      bool result =
                          await InternetConnectionChecker().hasConnection;
                      if (result == false) {
                        showAlertDialog(context);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MatchHistory(summonerInfo)));
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black, offset: Offset(0, 1), blurRadius: 6)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.summonerInfo['name'],
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: 'Friz Quadrata'),
                  ),
                  SizedBox(height: 15),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        'http://ddragon.leagueoflegends.com/cdn/' +
                            Provider.of<Version>(context, listen: false)
                                .version +
                            '/img/profileicon/'
                                '${widget.summonerInfo['profileIconId']}'
                                '.png'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Highest Masteries',
                    style: TextStyle(
                        fontFamily: 'Friz Quadrata',
                        color: Colors.white,
                        fontSize: 30),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '2nd',
                            style: TextStyle(
                                color: Color(0xFFc0c0c0),
                                fontFamily: 'Friz Quadrata'),
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                                'images/champion_icons/${widget.summonerMasteryInfo[1]['championId']}.png'),
                          ),
                          Image(
                            width: 40,
                            height: 40,
                            image: AssetImage(
                                'images/masteries/mastery_icon_${widget.summonerMasteryInfo[1]['championLevel']}.png'),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '1st',
                              style: TextStyle(
                                  color: Color(0xFFffe449),
                                  fontFamily: 'Friz Quadrata'),
                            ),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                  'images/champion_icons/${widget.summonerMasteryInfo[0]['championId']}.png'),
                            ),
                            Image(
                              width: 40,
                              height: 40,
                              image: AssetImage(
                                  'images/masteries/mastery_icon_${widget.summonerMasteryInfo[0]['championLevel']}.png'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            '3rd',
                            style: TextStyle(
                                color: Color(0xFF9c5221),
                                fontFamily: 'Friz Quadrata'),
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                                'images/champion_icons/${widget.summonerMasteryInfo[2]['championId']}.png'),
                          ),
                          Image(
                            width: 40,
                            height: 40,
                            image: AssetImage(
                                'images/masteries/mastery_icon_${widget.summonerMasteryInfo[2]['championLevel']}.png'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Ranked Solo',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Friz Quadrata'),
                          ),
                          SizedBox(height: 30),
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Color(0xFF041A26),
                            backgroundImage: AssetImage(
                                'images/ranked_icons/Emblem_${widget.summonerRankInfo.length > 0 ? widget.summonerRankInfo[0]['tier'] : 'UNRANKED'}.png'),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Ranked Flex',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Friz Quadrata'),
                          ),
                          SizedBox(height: 30),
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Color(0xFF041A26),
                            backgroundImage: AssetImage(
                                'images/ranked_icons/Emblem_${widget.summonerRankInfo.length > 1 ? widget.summonerRankInfo[1]['tier'] : 'UNRANKED'}.png'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text(
          "Please make sure you are connected to a network with an internet connection."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
