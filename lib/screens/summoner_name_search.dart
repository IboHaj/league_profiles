import 'dart:io';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:league_profiles/screens/summoner_screen.dart';
import 'package:league_profiles/screens/personal_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:league_profiles/constants.dart';
import 'package:provider/provider.dart';

class SearchName extends StatefulWidget {
  ValueNotifier area = ValueNotifier("EUW");
  @override
  _SearchNameState createState() => _SearchNameState();
}

class _SearchNameState extends State<SearchName> {
  String selectedRegion = 'EUW', personalSelectedRegion = 'EUW';
  String selectedRegionCode = 'euw1', personalSelectedRegionCode = 'euw1';
  String summonerName, personalSummonerName;
  bool showSpinner = false;
  var nameController = TextEditingController(),
      personalNameController = TextEditingController();
  String personalNameDirectory;
  StateSetter _setState;

  @override
  Widget build(BuildContext context) {
    final fileDirectory = localPath;
    Provider.of<SelectedRegion>(context).region = selectedRegion;
    widget.area.addListener(() {
      _setState(() {
        personalSelectedRegion = widget.area.value;
      });
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: kAppTheme,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width / 3,
          leading: TextButton(
            onPressed: () async {
              String localFileDirectory =
                  await fileDirectory + "/summonerSavedName.txt";
              personalNameDirectory = localFileDirectory;
              if (await File(localFileDirectory).exists() == true) {
                personalSummonerName =
                    (await File(localFileDirectory).readAsString()).toString();
                lookupSummonerName(personalSummonerName, true, false);
              } else {
                getDropDownButton(Colors.grey, true);
                showPersonalProfileAlert(context);
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                  size: 14,
                ),
                Text(
                  " Personal Profile",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontFamily: "Friz Quadrata"),
                )
              ],
            ),
          ),
          title: Container(
            child: Text(
              'League Profiles',
              style: TextStyle(fontFamily: 'Friz Quadrata'),
            ),
          ),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/Poro.jpg'),
                  radius: 80,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 200,
                      child: TextField(
                        onChanged: (value) {
                          summonerName = value;
                        },
                        controller: nameController,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                        showCursor: true,
                        decoration: InputDecoration(
                          hintText: ' Summoner Name ',
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    getDropDownButton(Colors.white, false)
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 40,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      lookupSummonerName(summonerName, false, false);
                    },
                    child: TextButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(21),
                      ),
                      child: Text(
                        'Search',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFFBD700))),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  lookupSummonerName(summonerName, personalOrNot, newName) async {
    try {
      http.Client client = http.Client();
      nameController.clear();
      setState(() {
        showSpinner = true;
      });
      var version = await fetch(client,
          Uri.parse('https://ddragon.leagueoflegends.com/api/versions.json'));
      Provider.of<Version>(context, listen: false).version =
          version[0].toString();
      parsedProfile = await fetch(
          client,
          Uri.parse(
              'https://$selectedRegionCode.api.riotgames.com/lol/summoner/v4/summoners/by-name/$summonerName?api_key=$kApiKey'));
      parsedMastery = await fetch(
          client,
          Uri.parse(
              'https://$selectedRegionCode.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/${parsedProfile['id']}?api_key=$kApiKey'));
      await setChampNames(parsedMastery, client,
          Provider.of<Version>(context, listen: false).version);
      parsedRank = await fetch(
          client,
          Uri.parse(
              'https://$selectedRegionCode.api.riotgames.com/lol/league/v4/entries/by-summoner/${parsedProfile['id']}?api_key=$kApiKey'));
      if (personalOrNot == true) {
        if (newName == true) {
          await localFile;
          await writeCounter("$summonerName");
          Navigator.of(context).pop();
        }
        setState(() {
          showSpinner = false;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  PersonalProfile(parsedProfile, parsedRank, parsedMastery)));
        });
      } else {
        setState(() {
          showSpinner = false;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  SummonerProfile(parsedProfile, parsedRank, parsedMastery)));
        });
      }
    } catch (e) {
      bool result = await InternetConnectionChecker().hasConnection;
      showAlertDialog(context, result);
      nameController.clear();
      setState(() {
        showSpinner = false;
      });
    }
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

  showPersonalProfileAlert(BuildContext context) {
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        showPersonalSummonerAlert(context);
      },
    );
    Widget noButton = TextButton(
        child: Text("No"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    AlertDialog personalProfile = AlertDialog(
      title: (Text("")),
      content: Text("Would you like to set up your personal profile ?"),
      actions: [yesButton, noButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return personalProfile;
        });
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
                              personalSummonerName = value;
                            },
                            controller: personalNameController,
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
                        setState(() {
                          showSpinner = true;
                        });
                        await lookupSummonerName(
                            personalSummonerName, true, true);
                      },
                      child: Text("Ok"))
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
      value: (personalOrGeneral ? personalSelectedRegion : selectedRegion),
      items: regions,
      underline: Container(
        width: 0,
        height: 1.5,
        color: underlineColor,
      ),
      onChanged: (value) {
        setState(() {
          if (personalOrGeneral == true) {
            personalSelectedRegion = value;
            widget.area.value = personalSelectedRegion;
          } else {
            selectedRegion = value;
          }
          selectedRegionCode = kRegionCodes[kRegionNames.indexOf(
              personalOrGeneral ? personalSelectedRegion : selectedRegion)];
          Provider.of<SelectedRegion>(context, listen: false).region = value;
        });
      },
    );
  }
}
