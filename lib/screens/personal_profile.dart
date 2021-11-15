import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:league_profiles/screens/match_history.dart';
import 'package:provider/provider.dart';
import 'package:league_profiles/constants.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PersonalProfile extends StatefulWidget {
  Map<String, dynamic> summonerInfo;
  var summonerMasteryInfo;
  var summonerRankInfo;
  ValueNotifier area = ValueNotifier("EUW");
  PersonalProfile(
      this.summonerInfo, this.summonerRankInfo, this.summonerMasteryInfo);

  @override
  _PersonalProfileState createState() => _PersonalProfileState(
      this.summonerInfo, this.summonerRankInfo, this.summonerMasteryInfo);
}

class _PersonalProfileState extends State<PersonalProfile> {
  String selectedRegion = "EUW";
  String selectedRegionCode = "euw1";
  String summonerName = "";
  StateSetter _setState;
  Map<String, dynamic> summonerInfo;
  var summonerMasteryInfo;
  var summonerRankInfo;
  var nameController = TextEditingController();
  bool showSpinner = false;
  _PersonalProfileState(
      this.summonerInfo, this.summonerRankInfo, this.summonerMasteryInfo);
  @override
  Widget build(BuildContext context) {
    widget.area.addListener(() {
      _setState(() {
        selectedRegion = widget.area.value;
      });
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          leading: Container(
            width: MediaQuery.of(context).size.width / 6,
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left_outlined),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            padding: EdgeInsets.only(right: 80),
            child: TextButton(
              child: Text("Change Summoner",
                  style: TextStyle(
                      fontFamily: "Friz Quadrata",
                      fontSize: 14,
                      color: Colors.white)),
              onPressed: () async {
                showPersonalSummonerAlert(context);
              },
            ),
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
                          showAlertDialog(context, false);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MatchHistory(widget.summonerInfo)));
                        }
                      }),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right_outlined),
                    onPressed: () async {
                      bool result =
                          await InternetConnectionChecker().hasConnection;
                      if (result == false) {
                        showAlertDialog(context, false);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MatchHistory(widget.summonerInfo)));
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Container(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 1),
                        blurRadius: 6)
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
      ),
    );
  }

  showAlertDialog(BuildContext context, bool connected) {
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
      content: Text(connected
          ? "Please enter a correct summoner name and make sure the region selected is correct."
          : "Please make sure you are connected to a network with an internet connection."),
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

  showPersonalSummonerAlert(BuildContext context) {
    AlertDialog personalSummoner = AlertDialog(
        title: Text("Enter your summoner name"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 15,
                          child: TextField(
                            onChanged: (value) {
                              summonerName = value;
                            },
                            controller: nameController,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                            showCursor: true,
                            decoration: InputDecoration(
                              hintText: ' Summoner Name ',
                              fillColor: Colors.grey,
                              hintStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                        getDropDownButton(Colors.grey, true)
                      ]),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await updateSummoner(summonerName);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFFBD700))),
                  )
                ],
              ),
            );
          },
        ));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return personalSummoner;
        });
  }

  updateSummoner(summonerName) async {
    try {
      http.Client client = http.Client();
      setState(() {
        showSpinner = true;
      });
      var version = await fetch(client,
          Uri.parse('https://ddragon.leagueoflegends.com/api/versions.json'));
      Provider.of<Version>(context, listen: false).version =
          version[0].toString();
      var localSummonerInfo = await fetch(
          client,
          Uri.parse(
              'https://$selectedRegionCode.api.riotgames.com/lol/summoner/v4/summoners/by-name/$summonerName?api_key=$kApiKey'));
      var localSummonerMastery = await fetch(
          client,
          Uri.parse(
              'https://$selectedRegionCode.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/${localSummonerInfo['id']}?api_key=$kApiKey'));
      setChampNames(localSummonerMastery, client,
          Provider.of<Version>(context, listen: false).version);
      var localSummonerRank = await fetch(
          client,
          Uri.parse(
              'https://$selectedRegionCode.api.riotgames.com/lol/league/v4/entries/by-summoner/${localSummonerInfo['id']}?api_key=$kApiKey'));
      await writeCounter("$summonerName");
      await readCounter();
      widget.summonerInfo = localSummonerInfo;
      widget.summonerMasteryInfo = localSummonerMastery;
      widget.summonerRankInfo = localSummonerRank;
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
      bool result = await InternetConnectionChecker().hasConnection;
      showAlertDialog(context, result);
      setState(() {
        showSpinner = false;
      });
    }
  }

  DropdownButton<String> getDropDownButton(
      Color underlineColor, bool personalOrGeneral) {
    List<DropdownMenuItem<String>> regions = [];

    for (String region in kRegionNames) {
      var newItem = DropdownMenuItem<String>(
        child: Text(
          region,
          style: TextStyle(color: Colors.grey),
        ),
        value: region,
      );
      regions.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedRegion,
      items: regions,
      underline: Container(
        width: 0,
        height: 1.5,
        color: underlineColor,
      ),
      onChanged: (value) {
        setState(() {
          selectedRegion = value;
          widget.area.value = selectedRegion;
          selectedRegionCode =
              kRegionCodes[kRegionNames.indexOf(selectedRegion)];
        });
      },
    );
  }
}
