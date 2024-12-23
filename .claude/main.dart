import 'package:flutter/material.dart';
import 'package:flutter_cards/GameBoard.dart';

void main() {
  runApp(const CardFlipApp());
}

class CardFlipApp extends StatelessWidget {
  const CardFlipApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Card Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GameBoard(),
    );
  }
}
