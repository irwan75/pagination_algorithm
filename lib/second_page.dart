import 'package:flutter/material.dart';
import 'package:pagination_algorithm/storage_preferences.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AlertDialog(
      title: Text("Mantapp"),
      content: Center(
        child: CircularProgressIndicator(),
      ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Mantapp Bosku"),
      ),
    );
  }
}
