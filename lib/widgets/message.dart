import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;
  Message(this.message);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        SizedBox(height: 55),
        Container(
          width: 80,
          height: 80,
          child: Image.asset(
            'assets/images/ball.png',
            color: Color.fromRGBO(255, 255, 255, 0.5),
            colorBlendMode: BlendMode.modulate,
          ),
        ),
        SizedBox(height: 20),
        FittedBox(
          child: Text(
            message,
            style: TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));
  }
}
