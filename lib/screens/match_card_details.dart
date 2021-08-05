import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:league_logger/screens/graphs.dart';
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:league_logger/constants.dart';


var plannedWidgets = <Widget>[];
var widgets = <Widget>[];
var matchDetailsTimeline;
var matchDetails;
var bar;
var timeLineWidgets = <TimelineEvent>[];
var expandedList = <Item>[];

class MatchDetails extends StatefulWidget {
  final String matchId;
  final String puuid;
  final String gameMode;
  MatchDetails(this.matchId, this.puuid, this.gameMode);

  @override
  _MatchDetailsState createState() =>
      _MatchDetailsState(this.matchId, this.puuid, this.gameMode);
}

class _MatchDetailsState extends State<MatchDetails> {
  var graph;
  String selectedOption = 'True Damage Dealt to Champions';
  final client = http.Client();
  final String matchId;
  final String puuid;
  final String gameMode;
  bool showSpinner = false;
  _MatchDetailsState(this.matchId, this.puuid, this.gameMode);

  @override
  void initState() {
    super.initState();
    startUp();
  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: MaterialApp(
        theme: kAppTheme,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.keyboard_arrow_left_outlined),
            color: Colors.white,
            onPressed: () {
                  matchDetails = null;
                  Navigator.pop(context);
            }),
              title: Text(
                'Match Details',
                style: TextStyle(fontFamily: "Friz Quadrata"),
              ),
              centerTitle: true,
            ),
            body: matchDetails == null? Container(): Container (
              child: ListView(children: <Widget>[
                TeamDetails(
                    Text(
                      'BLUE TEAM',
                      style: TextStyle(color: Color(0XFF0A96AA)),
                    ),
                    true),
                ObjectivesWidget(
                    matchDetails['info']['teams'][0]['objectives']['baron']
                    ['kills'],
                    (matchDetails['info']['teams'][0]['objectives']['dragon']
                    ['kills'] >
                        5
                        ? matchDetails['info']['teams'][0]['objectives']
                    ['dragon']['kills'] -
                        4
                        : 0),
                    matchDetails['info']['teams'][0]['objectives']['dragon']
                    ['kills'],
                    matchDetails['info']['teams'][0]['objectives']['tower']
                    ['kills'],
                    matchDetails['info']['teams'][1]['objectives']['baron']
                    ['kills'],
                    (matchDetails['info']['teams'][1]['objectives']['dragon']
                    ['kills'] >
                        5
                        ? matchDetails['info']['teams'][1]['objectives']
                    ['dragon']['kills'] -
                        4
                        : 0),
                    matchDetails['info']['teams'][1]['objectives']['dragon']
                    ['kills'],
                    matchDetails['info']['teams'][1]['objectives']['tower']
                    ['kills']),
                TeamDetails(
                    Text(
                      'RED TEAM',
                      style: TextStyle(color: Color(0XFFBE1E37)),
                    ),
                    false),
                Container(
                  height: MediaQuery.of(context).size.height / 1.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'GRAPHS',
                        style:
                        TextStyle(color: Color(0xFF041A26), fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      getOptionMenuGraph(),
                      Expanded(
                        flex: 13,
                        child: bar,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Timeline',
                        style:
                        TextStyle(color: Colors.blueAccent, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 13,
                        child: SingleChildScrollView(
                          child: ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded){
                              setState(() {
                                expandedList[index].isExpanded = !isExpanded;
                              });
                            },
                            children: expandedList.map((Item) => ExpansionPanel(
                              backgroundColor: Colors.white,
                              isExpanded: Item.isExpanded,
                              canTapOnHeader: true,
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(title: Item.headerValue );
                              }, body: ListTile(
                              tileColor: Colors.white,
                                  title: Item.expandedValue,

                            ),
                            )).toList(),
                          )
                        )
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  DropdownButton<String> getOptionMenuGraph() {
    List<DropdownMenuItem<String>> options = [];
    for (String option in kOptionsGraph) {
      var newOption = DropdownMenuItem<String>(
        child: Text(
          option,
          style: TextStyle(color: Colors.black),
        ),
        value: option,
      );
      options.add(newOption);
    }
    return DropdownButton<String>(
      elevation: 24,
      isExpanded: false,
      menuMaxHeight: MediaQuery.of(context).size.height / 3,
      items: options,
      value: selectedOption,
      icon: Icon(CupertinoIcons.arrowtriangle_down_fill),
      iconEnabledColor: Colors.black,
      dropdownColor: Colors.white,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      underline: Container(
        height: 4,
        color: Colors.black,
      ),
      onChanged: (value) {
        setState(() {
          selectedOption = value;
          graph = HorizontalBarChart.createGraph(
              getGraphValues(selectedOption.camelCase));
          bar = HorizontalBarChart.buildGraph(graph, true);
        });
      },
    );
  }
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
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

  Future<http.Response> clientGet(http.Client client, Uri url) async {
    final response = await client.get(url);
    return response;
  }

  Future<T> fetch<T>(http.Client client, Uri url) async {
    final response = await clientGet(client, url);
    return jsonDecode(response.body);
  }

  List<GraphValue> getGraphValues(String option) {
    List<GraphValue> values = [];
    ReCase choice = ReCase(option);
    for (var i in matchDetails['info']['participants']) {
      values.add(GraphValue(i['championName'], i['${choice.camelCase}']));
    }
    return values;
  }

  void startUp() async {
    setState(() {
      showSpinner = true;
    });
    try{
      final matchDetailsTimelineLocal = await fetch<Map<String, dynamic>>(
          client,
          Uri.parse(
              'https://${Provider.of<SelectedRegion>(context, listen: false).region == 'EUW' || Provider.of<SelectedRegion>(context , listen: false).region == 'EUNE' ? 'europe' : 'americas'}.api.riotgames.com/lol/match/v5/matches/${this.matchId}/timeline?api_key=$kApiKey'));
      final matchDetailsLocal = await fetch<Map<String, dynamic>>(
          client,
          Uri.parse(
              'https://${Provider.of<SelectedRegion>(context, listen: false).region == 'EUW' || Provider.of<SelectedRegion>(context, listen: false).region == 'EUNE' ? 'europe' : 'americas'}.api.riotgames.com/lol/match/v5/matches/${this.matchId}?api_key=$kApiKey'));
      matchDetailsTimeline = matchDetailsTimelineLocal;
      matchDetails = matchDetailsLocal;
      graph = HorizontalBarChart.createGraph(
          getGraphValues('Total Damage Dealt To Champions'));
      bar = HorizontalBarChart.buildGraph(graph, true);
      createTimelineEvents();
      expandedList = createItemList();
    }
    catch(e){
      bool result = await InternetConnectionChecker().hasConnection;
      if(result == false){
        showAlertDialog(context);
      }
    }
    setState(() {
      showSpinner = false;
    });
  }

  void createTimelineEvents(){
    for(var i in matchDetailsTimeline['info']['frames']){
      for (var j in i['events'] ){
        if(j['type'] == 'CHAMPION_KILL'){
          if(j['killerId'] - 1 == -1 ){
            timeLineWidgets.add(TimelineEvent(matchDetails['info']['participants'][j['victimId'] - 1]['championName'], matchDetails['info']['participants'][j['victimId'] - 1]['summonerName'], 'Executed', matchDetails['info']['participants'][j['victimId'] - 1]['championName'], matchDetails['info']['participants'][j['victimId'] - 1]['summonerName'], ('${DateTime.fromMillisecondsSinceEpoch(j['timestamp']).minute > 9 ? DateTime.fromMillisecondsSinceEpoch(j['timestamp']).minute : '0' + DateTime.fromMillisecondsSinceEpoch(j['timestamp']).minute.toString()}:${DateTime.fromMillisecondsSinceEpoch(j['timestamp']).second > 9 ? DateTime.fromMillisecondsSinceEpoch(j['timestamp']).second : '0'+DateTime.fromMillisecondsSinceEpoch(j['timestamp']).second.toString()}'), j['position']['x'], j['position']['y']));
          }
          else{
            timeLineWidgets.add(TimelineEvent(matchDetails['info']['participants'][j['killerId'] - 1]['championName'], matchDetails['info']['participants'][j['killerId'] - 1]['summonerName'], 'Defeated', matchDetails['info']['participants'][j['victimId'] - 1]['championName'], matchDetails['info']['participants'][j['victimId'] - 1]['summonerName'], ('${DateTime.fromMillisecondsSinceEpoch(j['timestamp']).minute > 9 ? DateTime.fromMillisecondsSinceEpoch(j['timestamp']).minute : '0' + DateTime.fromMillisecondsSinceEpoch(j['timestamp']).minute.toString()}:${DateTime.fromMillisecondsSinceEpoch(j['timestamp']).second > 9 ? DateTime.fromMillisecondsSinceEpoch(j['timestamp']).second : '0'+DateTime.fromMillisecondsSinceEpoch(j['timestamp']).second.toString()}'), j['position']['x'], j['position']['y']));
          }
        }
        else if(j['type'] == 'BUILDING_KILL'){
          if(j['buildingType'] == 'TOWER_BUILDING'){
            timeLineWidgets.add(TimelineEvent((j['killerId'] - 1 > 0 ? matchDetails['info']['participants'][(j['killerId'] - 1)]['championName'] : j['teamId'] == 100 ? 'Minion-200' : 'Minion-100' ), 'Minions', 'Destroyed', j['teamId'] == 100 ? 'tower-200' : 'tower-100' , 'Turret', ('${DateTime.fromMillisecondsSinceEpoch(j['timestamp']).minute > 9 ? DateTime.fromMillisecondsSinceEpoch(j['timestamp']).minute : '0' + DateTime.fromMillisecondsSinceEpoch(j['timestamp']).minute.toString()}:${DateTime.fromMillisecondsSinceEpoch(j['timestamp']).second > 9 ? DateTime.fromMillisecondsSinceEpoch(j['timestamp']).second : '0'+DateTime.fromMillisecondsSinceEpoch(j['timestamp']).second.toString()}'), j['position']['x'], j['position']['y']));
          }
        }
      }
    }
  }

  List<Item>createItemList(){
    List<Item> list = [];
    for(var i in timeLineWidgets){
      print(i.x);
      print(i.y);
      list.add(Item(expandedValue: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/objectives_icons/map${gameMode == 'ARAM' ? '12' : '11'}.png'))),
            alignment: Alignment((i.x - 7435) / 7435,  -(i.y - 7490) / 7490),
            child: SizedBox(height: 10, width: 10,child: Image(image: AssetImage('images/objectives_icons/arrow-199-128.png'),)),
          ),
        ),
      ), headerValue: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('images/champion_icons/${(i as TimelineEvent).champ1}.png'),
              backgroundColor: Colors.white,
            ),
          ),
          Expanded(flex: 3,
            child: Center(
              child: Text(
                '${(i as TimelineEvent).player1}',
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ),
          Expanded(flex: 2,
            child: Center(
              child: Text(
                (i as TimelineEvent).status,
                style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: "Friz Quadrata"),
              ),
            ),
          ),
          Expanded(
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('images/champion_icons/${(i as TimelineEvent).champ2}.png'),
              backgroundColor: Colors.white,
            ),
          ),
          Expanded(flex: 3,
            child: Center(
              child: Text(
                '${(i as TimelineEvent).player2}',
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ),
          Expanded(child: Center(child: Text((i as TimelineEvent).time, style: TextStyle(fontSize: 11, color: Colors.black),)))
        ],
      ),));
    }
    return list;
  }
}

class Item {
  Item({
    @required this.expandedValue,
    @required this.headerValue,
    this.isExpanded = false,
  });

  Widget expandedValue;
  Widget headerValue;
  bool isExpanded;
}


class TimelineEvent  {
  final String champ1,player1,champ2,player2,status,time;
  final int x,y;

  TimelineEvent(this.champ1 , this.player1, this.status, this.champ2, this.player2, this.time, this.x , this.y);
}

class ObjectivesWidget extends StatelessWidget {
  final int redBaron,
      redElder,
      redDragon,
      redTower,
      blueBaron,
      blueElder,
      blueDragon,
      blueTower;
  ObjectivesWidget(this.redBaron, this.redElder, this.redDragon, this.redTower,
      this.blueBaron, this.blueElder, this.blueDragon, this.blueTower);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        height: MediaQuery.of(context).size.height / 10,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                'OBJECTIVES',
                style: TextStyle(
                  color: Color(0xFF041A26),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  children: <Widget>[
                    ObjectiveWidget('baron-100', redBaron),
                    ObjectiveWidget('elder-100', redElder),
                    ObjectiveWidget('dragon-100', redDragon),
                    ObjectiveWidget('tower-100', redTower),
                    SizedBox(
                      width: 10,
                    ),
                    ObjectiveWidget('baron-200', blueBaron),
                    ObjectiveWidget('elder-200', blueElder),
                    ObjectiveWidget('dragon-200', blueDragon),
                    ObjectiveWidget('tower-200', blueTower),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class ObjectiveWidget extends StatelessWidget {
  final String icon;
  final int score;

  ObjectiveWidget(this.icon, this.score);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset('images/objectives_icons/$icon.png'),
            flex: 2,
          ),
          Expanded(child: Text(' :', style: TextStyle(color: Colors.black))),
          Expanded(
              flex: 2,
              child: Text(
                score.toString(),
                style: TextStyle(color: Colors.black, fontSize: 12),
              ))
        ],
      ),
    );
  }
}

class TeamDetails extends StatelessWidget {
  final Text team;
  final bool isFirst;

  TeamDetails(this.team, this.isFirst);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      height: MediaQuery.of(context).size.height / 2.8,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          team,
          PlayerDetails(isFirst ? 0 : 5),
          SizedBox(
            height: 1,
          ),
          PlayerDetails(isFirst ? 1 : 6),
          SizedBox(
            height: 1,
          ),
          PlayerDetails(isFirst ? 2 : 7),
          SizedBox(
            height: 1,
          ),
          PlayerDetails(isFirst ? 3 : 8),
          SizedBox(
            height: 1,
          ),
          PlayerDetails(isFirst ? 4 : 9),
        ],
      ),
    );
  }
}

class PlayerDetails extends StatelessWidget {
  final int index;
  PlayerDetails(this.index);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: CircleAvatar(
                  radius: 15,
                  foregroundImage: AssetImage(
                      'images/champion_icons/${matchDetails['info']['participants'][index]['championName']}.png')),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: CircleAvatar(
                        foregroundImage: AssetImage(
                            'images/summoner_spells/${matchDetails['info']['participants'][index]['summoner1Id'].toString()}.png'),
                      ),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        foregroundImage: AssetImage(
                            'images/summoner_spells/${matchDetails['info']['participants'][index]['summoner2Id'].toString()}.png'),
                      ),
                    )
                  ],
                )),
            SizedBox(
              width: 2,
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: CircleAvatar(
                        foregroundImage: AssetImage(
                            'images/runes/${matchDetails['info']['participants'][index]['perks']['styles'][0]['selections'][0]['perk']}.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        foregroundImage: AssetImage(
                            'images/runes/${matchDetails['info']['participants'][index]['perks']['styles'][1]['style']}.png'),
                        radius: 24,
                        backgroundColor: Colors.white,
                      ),
                    )
                  ],
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 5,
              child: Text(
                '${matchDetails['info']['participants'][index]['summonerName']}',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: <Widget>[
                  Text(
                      '${((matchDetails['info']['participants'][index]['kills'] + matchDetails['info']['participants'][index]['assists']) / matchDetails['info']['participants'][index]['deaths']).toStringAsFixed(1)} : 1',
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  Text(
                      '${matchDetails['info']['participants'][index]['kills']} / ${matchDetails['info']['participants'][index]['deaths']} / ${matchDetails['info']['participants'][index]['assists']}',
                      style: TextStyle(color: Colors.black, fontSize: 12))
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Text(
                    'CS',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                    '${matchDetails['info']['participants'][index]['totalMinionsKilled']}',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Image.asset(
                          'images/item_icons/${matchDetails['info']['participants'][index]['item0']}.png')),
                  Expanded(
                      child: Image.asset(
                          'images/item_icons/${matchDetails['info']['participants'][index]['item1']}.png')),
                  Expanded(
                      child: Image.asset(
                          'images/item_icons/${matchDetails['info']['participants'][index]['item2']}.png')),
                  Expanded(
                      child: Image.asset(
                          'images/item_icons/${matchDetails['info']['participants'][index]['item3']}.png')),
                  Expanded(
                      child: Image.asset(
                          'images/item_icons/${matchDetails['info']['participants'][index]['item4']}.png')),
                  Expanded(
                      child: Image.asset(
                          'images/item_icons/${matchDetails['info']['participants'][index]['item5']}.png')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
