import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:league_logger/screens/match_card_details.dart';

class MatchHistoryCard extends StatelessWidget {
  final championIcon,
      summonerSpell1,
      summonerSpell2,
      rune1,
      rune2,
      kills,
      deaths,
      assists,
      level,
      creepScore,
      item0,
      item1,
      item2,
      item3,
      item4,
      item5,
      date,
      gameType,
      gameDuration,
      endState,
      puuid,
      matchId,
      region;
  final client = http.Client();

  MatchHistoryCard(
      this.championIcon,
      this.summonerSpell1,
      this.summonerSpell2,
      this.rune1,
      this.rune2,
      this.kills,
      this.deaths,
      this.assists,
      this.level,
      this.creepScore,
      this.item0,
      this.item1,
      this.item2,
      this.item3,
      this.item4,
      this.item5,
      this.date,
      this.gameType,
      this.gameDuration,
      this.endState,
      this.puuid,
      this.matchId,
      this.region);

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

  String getDate(gameDate) {
    final date = DateTime.fromMillisecondsSinceEpoch(gameDate);
    return ('${date.day} ' '/' ' ${date.month}' ' /' '${date.year}');
  }

  @override
  Widget build(BuildContext context) {
    double KDA = (assists + kills) / deaths;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MatchDetails(matchId, puuid, gameType)));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 1), blurRadius: 6),
            ]),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(getDate(date)),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 5,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                'images/champion_icons/${championIcon}.png'),
                            radius: 25,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/runes/${rune1}.png'),
                                radius: 15,
                                backgroundColor: Colors.white,
                              ),
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/runes/${rune2}.png'),
                                radius: 12,
                                backgroundColor: Colors.white,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    'images/summoner_spells/${summonerSpell1}.png'),
                                radius: 15,
                                backgroundColor: Colors.white,
                              ),
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    'images/summoner_spells/${summonerSpell2}.png'),
                                radius: 15,
                                backgroundColor: Colors.white,
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: [
                              Text('${kills} / ${deaths} / ${assists}',
                                  style: TextStyle(fontSize: 12)),
                              Text(('${KDA.toStringAsFixed(1)} : 1'),
                                  style: TextStyle(fontSize: 14))
                            ],
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Lvl ' + level.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                        Text('CS ' + creepScore.toString(),
                            style: TextStyle(fontSize: 14))
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset(
                                      'images/item_icons/${item0}.png'),
                                ),
                                Expanded(
                                    child: Image.asset(
                                        'images/item_icons/${item1}.png')),
                                Expanded(
                                    child: Image.asset(
                                        'images/item_icons/${item2}.png')),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Image.asset(
                                        'images/item_icons/${item3}.png')),
                                Expanded(
                                    child: Image.asset(
                                        'images/item_icons/${item4}.png')),
                                Expanded(
                                    child: Image.asset(
                                        'images/item_icons/${item5}.png')),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                endState ? gameType + ' VICTORY ' : gameType + ' LOSS ',
                style: TextStyle(fontFamily: 'Fritz Quadrata', fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
