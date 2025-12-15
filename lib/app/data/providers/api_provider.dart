import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/storage_service.dart';
import 'package:get/get.dart';

class ApiProvider {

  // Backend API URL এখানে দিন
  static const String baseUrl = 'https://your-backend-api.com/api';

  final http.Client httpClient = http.Client();

  // Get token from storage
  String? _getToken() {
    final storageService = Get.find<StorageService>();
    return storageService.getToken();
  }

  // Build headers with authentication
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {'Content-Type': 'application/json'};

    if (includeAuth) {
      final token = _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ========== Auth Endpoints ==========

  // Sign Up
  Future<dynamic> signUp(String name, String email, String password) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: _getHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Login
  Future<dynamic> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Logout
  Future<dynamic> logout() async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _getHeaders(includeAuth: true),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get Current User
  Future<dynamic> getCurrentUser() async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: _getHeaders(includeAuth: true),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ========== Generic Methods ==========

  // GET request
  Future<dynamic> get(String endpoint, {bool requiresAuth = false}) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requiresAuth),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request
  Future<dynamic> post(
      String endpoint,
      Map<String, dynamic> data, {
        bool requiresAuth = false,
      }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requiresAuth),
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT request
  Future<dynamic> put(
      String endpoint,
      Map<String, dynamic> data, {
        bool requiresAuth = false,
      }) async {
    try {
      final response = await httpClient.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requiresAuth),
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(
      String endpoint, {
        bool requiresAuth = false,
      }) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requiresAuth),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Response handler with better error handling
  dynamic _handleResponse(http.Response response) {
    print('📡 API Response: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);

    } else if (response.statusCode == 401) {
      // Unauthorized - Token expired
      throw Exception('Unauthorized. Please login again.');

    } else if (response.statusCode == 404) {
      // Not Found
      throw Exception('Resource not found');

    } else if (response.statusCode == 422) {
      // Validation Error
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Validation failed');

    } else if (response.statusCode >= 500) {
      // Server Error
      throw Exception('Server error. Please try again later.');

    } else {
      // Other errors
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'API Error: ${response.statusCode}');
    }
  }

  // Close client
  void dispose() {
    httpClient.close();
  }
}