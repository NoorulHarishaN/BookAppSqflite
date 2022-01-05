import 'package:flutter/material.dart';
import 'BookScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Library'),
        backgroundColor: Colors.blueGrey,
      ),
      body: BookScreen(),
    );
  }
}
