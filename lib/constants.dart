import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

ThemeData kAppTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Color(0xFF041A26),
  primaryColor: Color(0xFF022865),
  backgroundColor: Color(0xFF041A26),
  tabBarTheme: TabBarTheme(
      labelColor: Color(0xFF041A26), unselectedLabelColor: Color(0xFF041A26)),
);

const TextStyle kTextStyle =
    TextStyle(fontFamily: 'Friz Quadrata', fontSize: 18);
const String kApiKey =
    'RGAPI-37e2578e-97ee-46f0-aecf-9f94a0577e94'; // Insert your API key here
const kRegionNames = ['EUNE', 'EUW', 'NA', 'OCE'];
const kRegionCodes = ['eun1', 'euw1', 'na1', 'oc1'];
const kOptionsGraph = <String>[
  'Total Damage Dealt',
  'Total Damage Dealt to Champions',
  'Magic Damage Dealt to Champions',
  'Physical Damage Dealt  to Champions',
  'True Damage Dealt to Champions',
  'Physical Damage Dealt',
  'Magic Damage Dealt',
  'True Damage Dealt',
  'Damage Dealt To Turrets',
  'Damage Dealt To Objectives',
  'Total Heal',
  'Total Damage Taken',
  'Physical Damage Taken',
  'Magical Damage Taken',
  'True Damage Taken',
  'Damage Self Mitigated',
  'Gold Earned',
  'Vision Score',
  'Wards Placed',
  'Wards Destroyed',
  'Control Wards Purchased',
];
var parsedProfile;
var parsedMastery = [];
var parsedRank;

class SelectedRegion {
  String region;
  SelectedRegion(this.region);
}

class Version {
  String version;
  Version(this.version);
}

Future<http.Response> clientGet(http.Client client, Uri url) async {
  final response = await client.get(url);
  return response;
}

Future<T> fetch<T>(http.Client client, Uri url) async {
  final response = await clientGet(client, url);
  return jsonDecode(response.body);
}

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/summonerSavedName.txt');
}

Future<File> writeCounter(String counter) async {
  final file = await localFile;

  // Write the file
  return file.writeAsString('$counter');
}

Future<int> readCounter() async {
  try {
    final file = await localFile;

    // Read the file
    final contents = await file.readAsString();
    print(contents);

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}

Future setChampNames(List<dynamic> data, http.Client client, version) async {
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
// App was made by IboHaj
