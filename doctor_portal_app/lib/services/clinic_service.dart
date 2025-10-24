import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clinic.dart';

class ClinicService {
  static const String _baseUrl = 'http://localhost:3000/api/clinics';

  // Get all clinics by doctor ID
  static Future<List<Clinic>> getClinicsByDoctor(String doctorId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/doctor/$doctorId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] && responseData['data'] != null) {
          List<dynamic> clinicsJson = responseData['data'];
          return clinicsJson.map((json) => Clinic.fromJson(json)).toList();
        }
      }
      return [];
    } catch (error) {
      print('Get clinics by doctor error: $error');
      return [];
    }
  }

  // Create new clinic
  static Future<Map<String, dynamic>> createClinic(Clinic clinic) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(clinic.toCreateJson()),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 && responseData['success']) {
        return {
          'success': true,
          'clinic': Clinic.fromJson(responseData['data']),
          'message': responseData['message']
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create clinic'
        };
      }
    } catch (error) {
      print('Create clinic error: $error');
      return {
        'success': false,
        'message': 'An error occurred. Please try again.'
      };
    }
  }

  // Update clinic
  static Future<Map<String, dynamic>> updateClinic(String clinicId, Clinic clinic) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$clinicId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(clinic.toUpdateJson()),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        return {
          'success': true,
          'clinic': Clinic.fromJson(responseData['data']),
          'message': responseData['message']
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update clinic'
        };
      }
    } catch (error) {
      print('Update clinic error: $error');
      return {
        'success': false,
        'message': 'An error occurred. Please try again.'
      };
    }
  }

  // Delete clinic
  static Future<Map<String, dynamic>> deleteClinic(String clinicId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$clinicId'),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        return {
          'success': true,
          'message': responseData['message']
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to delete clinic'
        };
      }
    } catch (error) {
      print('Delete clinic error: $error');
      return {
        'success': false,
        'message': 'An error occurred. Please try again.'
      };
    }
  }
}
