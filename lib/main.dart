import 'package:flutter/material.dart';
import 'word_cloud_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Cloud & K-means Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordCloudPage(),
    );
  }
}
