import '../models/user_model.dart';
import '../providers/api_provider.dart';

class AuthRepository {
  final ApiProvider apiProvider = ApiProvider();

  // Sign Up with Real API
  Future<User> signUp(String name, String email, String password) async {
    try {
      print('📤 Signing up user: $email');
      final response = await apiProvider.signUp(name, email, password);
      print('✅ Signup successful');

      // Parse user from response
      if (response['data'] != null && response['data']['user'] != null) {
        return User.fromJson(response['data']['user']);
      } else if (response['user'] != null) {
        return User.fromJson(response['user']);
      } else {
        return User.fromJson(response);
      }
    } catch (e) {
      print('❌ Signup error: $e');
      throw Exception('Registration failed: $e');
    }
  }

  // Login with Real API
  Future<User> login(String email, String password) async {
    try {
      print('📤 Logging in user: $email');
      final response = await apiProvider.login(email, password);
      print('✅ Login successful');
      if (response['data'] != null && response['data']['user'] != null) {
        return User.fromJson(response['data']['user']);
      } else if (response['user'] != null) {
        return User.fromJson(response['user']);
      } else {
        return User.fromJson(response);
      }

    } catch (e) {
      print('❌ Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  // Logout with Real API
  Future<void> logout() async {
    try {
      print('📤 Logging out user');
      await apiProvider.logout();
      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }

  // Get Current User
  Future<User> getCurrentUser() async {
    try {
      print('📤 Fetching current user');
      final response = await apiProvider.getCurrentUser();
      print('✅ User fetched successfully');
      if (response['data'] != null && response['data']['user'] != null) {
        return User.fromJson(response['data']['user']);
      } else if (response['user'] != null) {
        return User.fromJson(response['user']);
      } else {
        return User.fromJson(response);
      }
    } catch (e) {
      print('❌ Get user error: $e');
      throw Exception('Failed to get current user: $e');
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      print('📤 Requesting password reset for: $email');
      await apiProvider.post('/auth/forgot-password', {'email': email});
      print('✅ Password reset email sent');
    } catch (e) {
      print('❌ Forgot password error: $e');
      throw Exception('Failed to send reset email: $e');
    }
  }

  // Reset Password
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      print('📤 Resetting password');
      await apiProvider.post('/auth/reset-password', {
        'token': token,
        'password': newPassword,
      });
      print('✅ Password reset successful');
    } catch (e) {
      print('❌ Reset password error: $e');
      throw Exception('Failed to reset password: $e');
    }
  }

  // Update Profile
  Future<User> updateProfile(Map<String, dynamic> data) async {
    try {
      print('📤 Updating profile');
      final response = await apiProvider.put(
        '/auth/profile',
        data,
        requiresAuth: true,
      );
      print('✅ Profile updated');
      if (response['data'] != null && response['data']['user'] != null) {
        return User.fromJson(response['data']['user']);
      } else if (response['user'] != null) {
        return User.fromJson(response['user']);
      } else {
        return User.fromJson(response);
      }

    } catch (e) {
      print('❌ Update profile error: $e');
      throw Exception('Failed to update profile: $e');
    }
  }
}