import 'package:flutter/material.dart';
import 'package:league_logger/screens/summoner_name_search.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:league_logger/screens/test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  SelectedRegion chosenRegion = SelectedRegion('');
  Version currentVersion = Version('');
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(theme: kAppTheme, home: ExperimentWidget()),
      providers: [
        Provider<SelectedRegion>(create: (context) => chosenRegion),
        Provider<Version>(create: (context) => currentVersion),
      ],
    );
  }
}