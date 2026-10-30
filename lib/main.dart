import 'package:flutter/material.dart';

import 'screens/news_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Новости',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const NewsScreen(),
    );
  }
}
