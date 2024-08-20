import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserHomeScreen extends StatelessWidget {
  final FlutterSecureStorage storage;

  UserHomeScreen({Key? key, required this.storage}) : super(key: key);

  Future<String?> _getUserId() async {
    return await storage.read(key: 'user_id');
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    String? accessToken = await storage.read(key: 'access_token');
    String? userId = await _getUserId();

    if (userId == null) {
      print('User ID is null');
      return null;
    }

    var response = await http.get(
      Uri.parse('https://fmeywjtpla.execute-api.us-east-1.amazonaws.com/Prod/users/$userId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch user data');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('No se pudo cargar la información del usuario');
          } else {
            final userData = snapshot.data!;
            return Center(
              child: Text(
                'Bienvenido, ${userData['name']}\nEmail: ${userData['email']}',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}
