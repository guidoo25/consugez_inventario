import 'package:bcrypt/bcrypt.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Get all users
Future<List<User>> getUsers() async {
  try {
    final response = await http.get(Uri.parse('${Enviroments.apiurl}/users'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<User> users = data.map((item) => User.fromJson(item)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  } catch (error) {
    print(error);
    throw Exception('Error connecting to the server');
  }
}

// Delete user by id
Future<void> deleteUser(int id) async {
  try {
    final response =
        await http.delete(Uri.parse('${Enviroments.apiurl}/users/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['message']);
    } else {
      throw Exception('Failed to delete user');
    }
  } catch (error) {
    print(error);
    throw Exception('Error connecting to the server');
  }
}

// Update user by id
Future<void> updateUser(int id, String name, String email, int role) async {
  try {
    //final hashedPassword = await BCrypt.hashpw(password, 'qweqwewq');
    final body = jsonEncode({
      'name': name,
      'email': email,
      // 'password': hashedPassword,
      'role': role,
    });
    final response = await http
        .put(Uri.parse('${Enviroments.apiurl}/users/$id'), body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['message']);
    } else {
      throw Exception('Failed to update user');
    }
  } catch (error) {
    print(error);
    throw Exception('Error connecting to the server');
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final int role;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }
}
