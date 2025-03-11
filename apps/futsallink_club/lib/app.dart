import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final String flavor;

  const App({Key? key, required this.flavor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futsallink Club - $flavor',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Text('Rodando flavor: $flavor', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
