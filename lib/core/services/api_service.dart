import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supa_app/core/config/app_config.dart';
import 'package:supa_app/core/services/auth_service.dart';

class ApiService {
  final AuthService _authService = AuthService();

  /// Helper to get common headers including the Access Token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Lists all projects from the Pulse Backend
  Future<List<dynamic>> listProjects() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/api/projects'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Lists all organizations
  Future<List<dynamic>> listOrganizations() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/api/organizations'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
