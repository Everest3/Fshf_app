import 'package:flutter/material.dart';
import '../constants.dart';

class MatchCategory extends StatelessWidget {
  final String competitionName;
  final String roundNumber;
  final String date;
  MatchCategory({this.competitionName, this.roundNumber, this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 14, 0, 14),
            color: kLightGrayColor,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black, fontFamily: 'Roboto'),
                children: <TextSpan>[
                  TextSpan(
                      text: competitionName,
                      style: TextStyle(fontWeight: FontWeight.w900)),
                  TextSpan(
                    text: ' / $date / JAVA:$roundNumber',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
