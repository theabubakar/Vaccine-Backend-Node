import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doctor.dart';

class AuthService extends ChangeNotifier {
  static const String _baseUrl = 'http://localhost:3000/api/auth';
  Doctor? _currentDoctor;
  String? _token;

  Doctor? get currentDoctor => _currentDoctor;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _currentDoctor != null;

  AuthService() {
    _loadDoctorFromPrefs();
  }

  Future<void> _loadDoctorFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final doctorJson = prefs.getString('doctor');

    if (_token != null && doctorJson != null) {
      _currentDoctor = Doctor.fromJson(json.decode(doctorJson));
    }
    notifyListeners();
  }

  Future<String?> login(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'identifier': identifier,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        _token = responseData['token'];
        _currentDoctor = Doctor.fromJson(responseData['doctor']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('doctor', json.encode(_currentDoctor!.toJson()));
        notifyListeners();
        return null; // No error
      } else {
        return responseData['message'] ?? 'Login failed';
      }
    } catch (error) {
      print('Login error: $error');
      return 'An error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    _token = null;
    _currentDoctor = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('doctor');
    notifyListeners();
  }

  // Optional: Verify token with backend
  Future<bool> verifyToken() async {
    if (_token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        _currentDoctor = Doctor.fromJson(responseData['doctor']);
        notifyListeners();
        return true;
      } else {
        await logout(); // Token invalid, log out
        return false;
      }
    } catch (error) {
      print('Token verification error: $error');
      await logout();
      return false;
    }
  }
}
