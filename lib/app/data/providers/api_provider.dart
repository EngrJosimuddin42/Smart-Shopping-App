import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../../services/storage_service.dart';

class ApiProvider {
  // এটি মেইন API (গেটওয়ে)
  static const String baseUrl = 'http://10.0.2.2:8000/api';
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

  // Response handler with better error handling (FIXED)
  dynamic _handleResponse(http.Response response) {
    print('📡 API Response: ${response.statusCode}');
    print('📄 API Response Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }

      try {
        return jsonDecode(response.body);
      } on FormatException {
        print('❌ FormatException: Unexpected non-JSON response (possibly HTML or server error)');
        throw Exception('Server returned an invalid data format (e.g., HTML page instead of JSON). Status: ${response.statusCode}');
      }

    } else if (response.statusCode == 401) {
      // Unauthorized - Token expired
      throw Exception('Unauthorized. Please login again.');

    } else if (response.statusCode == 404) {
      // Not Found
      throw Exception('Resource not found');

    } else if (response.statusCode == 422) {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Validation failed');
      } on FormatException {
        throw Exception('Validation failed, but server response format was invalid.');
      }


    } else if (response.statusCode >= 500) {
      // Server Error
      throw Exception('Server error. Please try again later.');

    } else {
      // Other errors
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'API Error: ${response.statusCode}');
      } on FormatException {
        throw Exception('API Error: ${response.statusCode}. Could not parse error details.');
      }
    }
  }

  // Close client
  void dispose() {
    httpClient.close();
  }
}