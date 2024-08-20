import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'admin/admin_home_screen.dart';
import 'user/user_home_screen.dart';
import 'user/user_register_screen.dart';

class LoginScreen extends StatefulWidget {
  final FlutterSecureStorage storage;

  const LoginScreen({Key? key, required this.storage}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isFirstLogin = false;

  Future<void> loginUser(String username, String password, {String? newPassword}) async {
    final url = Uri.parse('https://fmeywjtpla.execute-api.us-east-1.amazonaws.com/Prod/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
          if (newPassword != null) 'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('id_token') && data.containsKey('access_token') && data.containsKey('role')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inicio de sesión exitoso')),
          );

          String role = data['role'];
          String idToken = data['id_token'];
          Map<String, dynamic> decodedToken = JwtDecoder.decode(idToken);
          String userId = decodedToken['sub'];  // 'sub' es comúnmente utilizado para el user ID

          // Almacena los tokens y el user ID de forma segura
          await widget.storage.write(key: 'id_token', value: idToken);
          await widget.storage.write(key: 'access_token', value: data['access_token']);
          await widget.storage.write(key: 'refresh_token', value: data['refresh_token']);
          await widget.storage.write(key: 'user_id', value: userId);

          // Redirige a la pantalla adecuada según el rol del usuario
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHomeScreen()),
            );
          } else if (role == 'usuario') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserHomeScreen(storage: widget.storage)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rol no reconocido')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error inesperado: ${response.body}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al intentar iniciar sesión')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 40),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (isFirstLogin) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final username = usernameController.text;
                  final password = passwordController.text;
                  final newPassword = newPasswordController.text;

                  if (username.isNotEmpty && password.isNotEmpty) {
                    loginUser(username, password, newPassword: isFirstLogin ? newPassword : null);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, ingrese todas las credenciales')),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserRegistrationScreen(storage: widget.storage)),
                  );
                },
                child: const Text(
                  '¿No tienes una cuenta? Regístrate',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
