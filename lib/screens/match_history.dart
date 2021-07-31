import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:league_logger/widgets/match_history_card.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:league_logger/constants.dart';

class MatchHistory extends StatefulWidget {
  final summonerProfile;
  MatchHistory(this.summonerProfile);

  @override
  _MatchHistoryState createState() => _MatchHistoryState(summonerProfile);
}

class _MatchHistoryState extends State<MatchHistory> {
  final client = http.Client();
  bool showSpinner = true;
  var gamesNormal = <Widget>[];
  var gamesRanked = <Widget>[];
  final summonerProfile;
  var matchHistoryIDs;
  var matchHistory;
  ScrollController normalGamesScroll = ScrollController();
  ScrollController rankedGamesScroll = ScrollController();
  _MatchHistoryState(this.summonerProfile);
  @override
  void initState() {
    super.initState();
    startup();
  }

  void startup() async {
    final mathHistoryIDs = await fetch<List<dynamic>>(
        client,
        Uri.parse(
            'https://${Provider.of<SelectedRegion>(context).region == 'EUW' || Provider.of<SelectedRegion>(context).region == 'EUNE' ? 'europe' : 'americas'}.api.riotgames.com/lol/match/v5/matches/by-puuid/${summonerProfile['puuid']}/ids?start=0&count=20&api_key=$kApiKey'),
        '');
    this.matchHistoryIDs = mathHistoryIDs;
    createCards(matchHistoryIDs);
  }

  Future<http.Response> clientGet(http.Client client, Uri url) async {
    final response = await client.get(url);
    return response;
  }

  Future<T> fetch<T>(http.Client client, Uri url, String data) async {
    final response = await clientGet(client, url);
    return data == ''
        ? jsonDecode(response.body)
        : jsonDecode(response.body)[data];
  }

  String getGameType(queueType) {
    String string;
    switch (queueType) {
      case 0:
        {
          string = 'CUSTOM';
          break;
        }
      case 400:
        {
          string = 'NORMAL DRAFT';
          break;
        }
      case 420:
        {
          string = 'RANKED';
          break;
        }
      case 430:
        {
          string = 'NORMAL BLIND';
          break;
        }
      case 440:
        {
          string = 'RANKED FLEX';
          break;
        }
      case 450:
        {
          string = 'ARAM';
          break;
        }
      case 1300:
        {
          string = 'NEXUS BLITZ';
          break;
        }
      case 1450:
        {
          string = 'ULTIMATE SPELLBOOK';
          break;
        }
      default:
        {
          string = 'NORMAL';
          break;
        }
    }
    return string;
  }

  void getMoreMatches() async {
    final moreMatches = await fetch<List<dynamic>>(
        client,
        Uri.parse(
            'https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/${summonerProfile['puuid']}/ids?start=${gamesNormal.length}&count=${gamesNormal.length + 20}&api_key=$kApiKey'),
        '');
    matchHistoryIDs = moreMatches;
    addCards(matchHistoryIDs);
    setState(() {
      showSpinner = true;
    });
  }

  void addCards(matchHistoryIDs) async {
    var gamesRanked = <Widget>[];
    var gamesNormal = <Widget>[];
    for (var i in matchHistoryIDs) {
      var matchHistoryDetails = await fetch<Map<String, dynamic>>(
          client,
          Uri.parse(
              'https://${Provider.of<SelectedRegion>(context).region == 'EUW' || Provider.of<SelectedRegion>(context).region == 'EUNE' ? 'europe' : 'americas'}.api.riotgames.com/lol/match/v5/matches/$i?api_key=$kApiKey'),
          'info');
      for (var j in matchHistoryDetails['participants']) {
        if (j['puuid'] == summonerProfile['puuid']) {
          print(matchHistoryDetails['queueId']);
          if (matchHistoryDetails['queueId'] != 420 &&
              matchHistoryDetails['queueId'] != 440) {
            gamesNormal.add(MatchHistoryCard(
                j['championName'],
                j['summoner1Id'],
                j['summoner2Id'],
                j['perks']['styles'][0]['selections'][0]['perk'],
                j['perks']['styles'][1]['style'],
                j['kills'],
                j['deaths'],
                j['assists'],
                j['champLevel'],
                j['totalMinionsKilled'],
                j['item0'],
                j['item1'],
                j['item2'],
                j['item3'],
                j['item4'],
                j['item5'],
                matchHistoryDetails['gameCreation'],
                getGameType(matchHistoryDetails['queueId']),
                matchHistoryDetails['gameduration'],
                j['win'],
                summonerProfile['puuid'],
                i,
                Provider.of<String>(context)[1]));
          } else {
            gamesRanked.add(MatchHistoryCard(
                j['championName'],
                j['summoner1Id'],
                j['summoner2Id'],
                j['perks']['styles'][0]['selections'][0]['perk'],
                j['perks']['styles'][1]['style'],
                j['kills'],
                j['deaths'],
                j['assists'],
                j['champLevel'],
                j['totalMinionsKilled'],
                j['item0'],
                j['item1'],
                j['item2'],
                j['item3'],
                j['item4'],
                j['item5'],
                matchHistoryDetails['gameCreation'],
                getGameType(matchHistoryDetails['queueId']),
                matchHistoryDetails['gameduration'],
                j['win'],
                summonerProfile['puuid'],
                i,
                Provider.of<String>(context)[1]));
          }
        }
      }
    }
    setState(() {
      showSpinner = false;
      this.gamesNormal.addAll(gamesNormal);
      this.gamesRanked.addAll(gamesRanked);
    });
  }

  void scrollUp(ScrollController controller) {
    if (controller.position.pixels != 0) {
      controller.jumpTo(controller.position.pixels - 20);
    }
  }

  void createCards(matchHistoryIDs) async {
    var gamesRanked = <Widget>[];
    var gamesNormal = <Widget>[];
    for (var i in matchHistoryIDs) {
      var matchHistoryDetails = await fetch<Map<String, dynamic>>(
          client,
          Uri.parse(
              'https://${Provider.of<SelectedRegion>(context).region == 'EUW' || Provider.of<SelectedRegion>(context).region == 'EUNE' ? 'europe' : 'americas'}.api.riotgames.com/lol/match/v5/matches/$i?api_key=$kApiKey'),
          'info');
      for (var j in matchHistoryDetails['participants']) {
        if (j['puuid'] == summonerProfile['puuid']) {
          print(matchHistoryDetails['queueId']);
          if (matchHistoryDetails['queueId'] != 420 &&
              matchHistoryDetails['queueId'] != 440) {
            gamesNormal.add(MatchHistoryCard(
                j['championName'],
                j['summoner1Id'],
                j['summoner2Id'],
                j['perks']['styles'][0]['selections'][0]['perk'],
                j['perks']['styles'][1]['style'],
                j['kills'],
                j['deaths'],
                j['assists'],
                j['champLevel'],
                j['totalMinionsKilled'],
                j['item0'],
                j['item1'],
                j['item2'],
                j['item3'],
                j['item4'],
                j['item5'],
                matchHistoryDetails['gameCreation'],
                getGameType(matchHistoryDetails['queueId']),
                matchHistoryDetails['gameduration'],
                j['win'],
                summonerProfile['puuid'],
                i,
                Provider.of<SelectedRegion>(context).region));
          } else {
            gamesRanked.add(MatchHistoryCard(
                j['championName'],
                j['summoner1Id'],
                j['summoner2Id'],
                j['perks']['styles'][0]['selections'][0]['perk'],
                j['perks']['styles'][1]['style'],
                j['kills'],
                j['deaths'],
                j['assists'],
                j['champLevel'],
                j['totalMinionsKilled'],
                j['item0'],
                j['item1'],
                j['item2'],
                j['item3'],
                j['item4'],
                j['item5'],
                matchHistoryDetails['gameCreation'],
                getGameType(matchHistoryDetails['queueId']),
                matchHistoryDetails['gameduration'],
                j['win'],
                summonerProfile['puuid'],
                i,
                Provider.of<SelectedRegion>(context).region));
          }
        }
      }
    }
    setState(() {
      showSpinner = false;
      this.gamesNormal = gamesNormal;
      this.gamesRanked = gamesRanked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left_outlined),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              centerTitle: true,
              automaticallyImplyLeading: true,
              title: Text(
                'Match History',
                style: TextStyle(fontFamily: 'Friz Quadrata'),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text('Normal',
                        style: TextStyle(fontFamily: 'Friz Quadrata')),
                  ),
                  Tab(
                    child: Text('Ranked',
                        style: TextStyle(fontFamily: 'Friz Quadrata')),
                  )
                ],
              ),
            ),
            body: Container(
              child: TabBarView(
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: NotificationListener<ScrollEndNotification>(
                      child: ListView(
                        children: gamesNormal,
                        controller: normalGamesScroll,
                      ),
                      onNotification: (notification) {
                        if (normalGamesScroll.position.pixels ==
                            normalGamesScroll.position.maxScrollExtent) {
                          getMoreMatches();
                          scrollUp(normalGamesScroll);
                        }
                        return true;
                      },
                    ),
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: NotificationListener<ScrollNotification>(
                      child: ListView(
                        controller: rankedGamesScroll,
                        children: gamesRanked,
                      ),
                      onNotification: (notification) {
                        if (rankedGamesScroll.position.pixels ==
                            rankedGamesScroll.position.maxScrollExtent) {
                          getMoreMatches();
                          scrollUp(rankedGamesScroll);
                        }
                        return true;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
