// Updated Flutter imports

import 'package:flutter/material.dart';
import 'package:your_package/your_package.dart'; // Replace with your actual package imports

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creemos App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello, Creemos!'),
        ),
      ),
    );
  }
}