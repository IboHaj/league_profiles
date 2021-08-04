import 'package:flutter/material.dart';
import 'package:league_logger/screens/summoner_name_search.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SelectedRegion chosenRegion = SelectedRegion('');
    Version currentVersion = Version('');
    return MultiProvider(
      child: MaterialApp(theme: kAppTheme, home: SearchName()),
      providers: [
        Provider<SelectedRegion>(create: (context) => chosenRegion),
        Provider<Version>(create: (context) => currentVersion),
      ],
    );
  }
}
