import 'package:flutter/material.dart';
import 'series_list/SeriesList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Ecole code',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SeriesList(),
    );
  }
}
