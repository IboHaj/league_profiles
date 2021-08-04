import 'package:flutter/material.dart';

ThemeData kAppTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Color(0xFF041A26),
  primaryColor: Color(0xFF022865),
  backgroundColor: Color(0xFF041A26),
  accentColor: Color(0xFF041A26),
  tabBarTheme: TabBarTheme(
      labelColor: Color(0xFF041A26), unselectedLabelColor: Color(0xFF041A26)),
);

const TextStyle kTextStyle =
    TextStyle(fontFamily: 'Friz Quadrata', fontSize: 18);
const String kApiKey = 'RGAPI-69d0a0dc-4aff-4f58-bcc3-74d836f8f0ff';
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

class SelectedRegion {
  String region;
  SelectedRegion(this.region);
}

class Version {
  String version;
  Version(this.version);
}
