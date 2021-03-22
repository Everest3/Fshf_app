import 'package:flutter/material.dart';

class Match {
  final String id;
  final String competitionName;
  final String roundNumber;
  final String homeTeam;
  final String awayTeam;
  final String homeTeamFlag;
  final String awayTeamFlag;
  final String date;
  final String ftResult;

  Match({
    @required this.id,
    @required this.competitionName,
    @required this.roundNumber,
    @required this.homeTeam,
    @required this.awayTeam,
    @required this.homeTeamFlag,
    @required this.awayTeamFlag,
    @required this.date,
    @required this.ftResult,
  });
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      competitionName: json['competitionName'],
      roundNumber: json['roundNumber'],
      homeTeam: json['homeTeam'],
      awayTeam: json['awayTeam'],
      homeTeamFlag: json['homeTeamFlag'],
      awayTeamFlag: json['awayTeamFlag'],
      date: json['date'],
      ftResult: json['date'],
    );
  }
}
