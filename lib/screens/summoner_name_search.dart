import 'dart:convert';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:league_logger/screens/summoner_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:league_logger/constants.dart';
import 'package:provider/provider.dart';

class SearchName extends StatefulWidget {
  const SearchName({Key key}) : super(key: key);

  @override
  _SearchNameState createState() => _SearchNameState();
}

class _SearchNameState extends State<SearchName> {
  String selectedRegion = 'EUW';
  String selectedRegionCode = 'euw1';
  String summonerName;
  bool showSpinner = false;
  var parsedProfile;
  var parsedMastery = [];
  var parsedRank;
  var nameController = TextEditingController();

  Future<http.Response> clientGet(http.Client client, Uri url) async {
    final response = await client.get(url);
    return response;
  }

  Future<T> fetch<T>(http.Client client, Uri url) async {
    final response = await clientGet(client, url);
    return jsonDecode(response.body);
  }

  void setChampNames(List<dynamic> data, http.Client client, version) async {
    final champIDs = await client.get(Uri.parse(
        'http://ddragon.leagueoflegends.com/cdn/' +
            version +
            '/data/en_GB/champion.json'));
    Map<String, dynamic> list = jsonDecode(champIDs.body)['data'];
    final keys = list.keys;
    for (var i in keys) {
      for (int j = 0; j < 3; j++) {
        if (list[i]['key'].toString() == data[j]['championId'].toString()) {
          data[j]['championId'] = i;
        }
      }
    }
    parsedMastery = data;
    print(parsedMastery);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SelectedRegion>(context).region = selectedRegion;
    return MaterialApp(
      theme: kAppTheme,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'League Profiles',
            style: TextStyle(fontFamily: 'Friz Quadrata'),
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
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                        showCursor: true,
                        decoration: InputDecoration(
                          hintText: ' Summoner Name ',
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.white),
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
                    getDropDownButton()
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
                      try {
                        http.Client client = http.Client();
                        nameController.clear();
                        setState(() {
                          showSpinner = true;
                        });
                        var version = await fetch(
                            client,
                            Uri.parse(
                                'https://ddragon.leagueoflegends.com/api/versions.json'));
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
                        setChampNames(
                            parsedMastery,
                            client,
                            Provider.of<Version>(context, listen: false)
                                .version);
                        parsedRank = await fetch(
                            client,
                            Uri.parse(
                                'https://$selectedRegionCode.api.riotgames.com/lol/league/v4/entries/by-summoner/${parsedProfile['id']}?api_key=$kApiKey'));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SummonerProfile(
                                parsedProfile, parsedRank, parsedMastery)));
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        bool result =
                            await InternetConnectionChecker().hasConnection;
                        showAlertDialog(context, result);
                        nameController.clear();
                        setState(() {
                          showSpinner = false;
                        });
                      }
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

  DropdownButton<String> getDropDownButton() {
    List<DropdownMenuItem<String>> regions = [];

    for (String region in kRegionNames) {
      var newItem = DropdownMenuItem<String>(
        child: Text(
          region,
          style: TextStyle(color: Colors.white),
        ),
        value: region,
      );
      regions.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedRegion,
      items: regions,
      onChanged: (value) {
        setState(() {
          selectedRegion = value;
          selectedRegionCode =
              kRegionCodes[kRegionNames.indexOf(selectedRegion)];
          print(selectedRegionCode);
          Provider.of<SelectedRegion>(context, listen: false).region = value;
        });
      },
    );
  }
}
