import 'package:flutter/material.dart';
import 'package:fshf_app/constants.dart';

class Match extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String homeTeamFlag;
  final String awayTeamFlag;
  final String ftResult;
  Match({
    this.homeTeam,
    this.awayTeam,
    this.homeTeamFlag,
    this.awayTeamFlag,
    this.ftResult,
  });

  @override
  Widget build(BuildContext context) {
    final String homeTeamScore =
        ftResult.substring(0, ftResult.indexOf('-')).trim();
    final String awayTeamScore =
        ftResult.substring(ftResult.indexOf('-') + 1).trim();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTeam(homeTeam, homeTeamFlag),
                  SizedBox(height: 5),
                  buildTeam(awayTeam, awayTeamFlag),
                ],
              ),
              Spacer(),
              Text(
                'FT',
                style: TextStyle(
                    color: kRedColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Column(
                children: [
                  buildScoreBox(homeTeamScore, 'top'),
                  buildScoreBox(awayTeamScore, 'bottom'),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(
            color: Colors.grey[900],
            height: 4,
          ),
        ],
      ),
    );
  }
}

Widget buildScoreBox(String score, String boxPosition) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 3),
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      border: Border.all(color: kRedColor, width: 1),
      borderRadius: boxPosition == 'top'
          ? BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            )
          : BorderRadius.only(
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            ),
    ),
    child: Text(
      score,
    ),
  );
}

Widget buildTeam(String teamName, String teamFlag) {
  return Row(children: [
    Container(
      width: 23,
      height: 23,
      child: FadeInImage(
        placeholder: AssetImage('assets/images/ball.png'),
        image: NetworkImage(teamFlag),
        fit: BoxFit.cover,
      ),
    ),
    SizedBox(width: 4),
    Text(teamName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
  ]);
}
