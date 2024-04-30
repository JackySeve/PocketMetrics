import 'package:flutter/material.dart';

class registerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hola Mundo en Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hola Mundo'),
        ),
        body: Center(
          child: Text(
            '¡Hola Mundo!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
