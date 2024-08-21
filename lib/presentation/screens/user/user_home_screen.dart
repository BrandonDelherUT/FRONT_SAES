import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserHomeScreen extends StatelessWidget {
  final FlutterSecureStorage storage;

  UserHomeScreen({Key? key, required this.storage}) : super(key: key);

  Future<String?> _getUserId() async {
    try {
      String? userId = await storage.read(key: 'user_id');
      if (userId == null) {
        print('User ID is null');
      }
      return userId;
    } catch (e) {
      print('Failed to read user ID from storage: $e');
      return null;
    }
  }

  Future<String?> _getAccessToken() async {
    try {
      String? accessToken = await storage.read(key: 'access_token');
      if (accessToken == null) {
        print('Access Token is null');
      }
      return accessToken;
    } catch (e) {
      print('Failed to read access token from storage: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    try {
      String? userId = await _getUserId();
      String? accessToken = await _getAccessToken();

      if (userId == null || accessToken == null) {
        print('User ID or Access Token is null');
        return null;
      }

      var response = await http.get(
        Uri.parse('https://w3fza4o2mc.execute-api.us-east-1.amazonaws.com/Prod/users/$userId/profile'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No se pudo cargar la información del usuario'));
          } else {
            final userProfile = snapshot.data ?? {};
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenido, ${userProfile['first_name'] ?? ''} ${userProfile['last_name'] ?? ''}',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Teléfono: ${userProfile['phone'] ?? ''}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Dirección: ${userProfile['address'] ?? ''}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
