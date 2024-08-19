import 'package:flutter/material.dart';

class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home'),
      ),
      body: Center(
        child: Text(
          'Bienvenido, Usuario',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
