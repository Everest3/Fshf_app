import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'widgets/match_category.dart';
import 'dart:core';

import './models/matches.dart' as m;
import './widgets/match.dart';
import './widgets/message.dart';
import './constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Color(0xFF682D35));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fshf',
      theme: ThemeData(
        fontFamily: "Roboto",
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<m.Match> matches;
  Map<String, List<m.Match>> data;
  var matchCategory;
  String dateStr;
  bool loaded = false;
  bool firstRun = true;
  // bool firstLoading = true;

  Future<void> fetchMatches(String date) async {
    setState(() {
      loaded = false;
    });
    final response =
        await http.get(Uri.https('app.fshf.org', 'json/byDate/$date'));
    if (response.statusCode == 200) {
      final List<m.Match> loadedMatches = [];
      final extractedData = json.decode(response.body) as List<dynamic>;
      print(extractedData);
      Map<String, List<m.Match>> loadedData = {};

      if (extractedData != null) {
        extractedData.forEach((value) {
          loadedMatches.add(m.Match(
            id: value['id'],
            competitionName: value['competition_name'],
            roundNumber: value['round_number'],
            homeTeam: value['home_team'],
            awayTeam: value['away_team'],
            homeTeamFlag: value['home_team_flag'],
            awayTeamFlag: value['away_team_flag'],
            date: value['date'],
            ftResult: value['ft_result'],
          ));
        });
      }
      matches = loadedMatches;
      //nxjerrim kategorite e vecanta
      matchCategory = matches.map((e) => e.competitionName).toSet().toList();

      // krijojme nje map qe jep gjith skuadrat per secilen kategori
      for (var i = 0; i < matchCategory.length; i++) {
        List<m.Match> temp = [];
        loadedData.putIfAbsent(matchCategory[i], () => temp);
        for (var j = 0; j < matches.length; j++) {
          if (matchCategory[i] == matches[j].competitionName) {
            temp.add(matches[j]);
            loadedData.update(
              matchCategory[i],
              (value) => temp,
            );
          }
        }
      }
      print(loaded);
      print(firstRun);
      print(loadedData);
      data = loadedData;
      setState(() {
        loaded = true;
        firstRun = false;
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  void datePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.parse('2020-11-14'),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      fetchMatches(dateStr);
      setState(() {
        dateStr = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: AssetImage('assets/images/cover5.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 25),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: 26.0, color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(text: 'Rezultate'),
                          TextSpan(
                              text: 'Live',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2.0, color: kLightGrayColor),
                      left: BorderSide(width: 2.0, color: kLightGrayColor),
                      bottom: BorderSide(width: 2.0, color: kLightGrayColor),
                    ),
                  ),
                  child: Text(
                    'Live',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: kLightGrayColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Text(
                          dateStr == null ? "Chose date" : '$dateStr',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.0,
                        width: 18.0,
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.date_range,
                              size: 20,
                            ),
                            onPressed: () => datePicker(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            firstRun
                ? Message('Zgjidhni një datë për të shfaqur ndeshjet!')
                : (loaded && matches.isNotEmpty)
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...data.entries.map((entry) {
                                  return Column(
                                    children: [
                                      MatchCategory(
                                        competitionName:
                                            entry.value[0].competitionName,
                                        roundNumber: entry.value[0].roundNumber,
                                        date: entry.value[0].date,
                                      ),
                                      Column(
                                        children: [
                                          ...entry.value.map((match) {
                                            return Match(
                                              homeTeam: match.homeTeam,
                                              awayTeam: match.awayTeam,
                                              homeTeamFlag: match.homeTeamFlag,
                                              awayTeamFlag: match.awayTeamFlag,
                                              ftResult: match.ftResult,
                                            );
                                          }).toList()
                                        ],
                                      )
                                    ],
                                  );
                                }).toList()
                              ],
                            ),
                          ),
                        ),
                      )
                    : (loaded && matches.isEmpty)
                        ? Message('Nuk ka ndeshje per daten $dateStr')
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
          ],
        ),
      ),
    );
  }
}
