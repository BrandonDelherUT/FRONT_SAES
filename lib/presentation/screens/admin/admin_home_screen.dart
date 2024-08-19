import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
      ),
      body: Center(
        child: Text(
          'Bienvenido, Admin',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
