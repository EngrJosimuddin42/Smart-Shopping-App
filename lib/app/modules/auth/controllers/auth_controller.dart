import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final StorageService _storageService = Get.find<StorageService>();

  // ========== Reactive Properties ==========
  var currentUser = Rxn<User>(); // Nullable user
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var isPasswordHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    print('✅ AuthController initialized');
    checkLoginStatus();
  }

  // Check login status from storage
  void checkLoginStatus() {
    final user = _storageService.getUser();
    if (user != null) {
      currentUser.value = user;
      isLoggedIn.value = true;
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // ========== Sign Up ==========
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'সব ফিল্ড পূরণ করুন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    // Name validation
    if (name.length < 3) {
      Get.snackbar(
        'Error',
        'নাম কমপক্ষে ৩ অক্ষরের হতে হবে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    // Email validation
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'সঠিক ইমেইল দিন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    // Password length validation
    if (password.length < 6) {
      Get.snackbar(
        'Error',
        'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    // Password match validation
    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'পাসওয়ার্ড মিলছে না',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Call repository signup method
      final user = await _authRepository.signUp(name, email, password);

      // Save user to storage
      await _storageService.saveUser(user);
      await _storageService.saveToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');

      currentUser.value = user;
      isLoggedIn.value = true;

      Get.snackbar(
        'Success',
        'একাউন্ট তৈরি সফল হয়েছে! 🎉',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to home
      Get.offAllNamed(Routes.HOME);

    } catch (e) {
      Get.snackbar(
        'Error',
        'একাউন্ট তৈরি ব্যর্থ হয়েছে: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== Login ==========
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'সব ফিল্ড পূরণ করুন',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      final user = await _authRepository.login(email, password);

      // Save user to storage
      await _storageService.saveUser(user);
      await _storageService.saveToken('mock_token_12345');

      currentUser.value = user;
      isLoggedIn.value = true;

      Get.snackbar('Success', 'লগইন সফল হয়েছে!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      // Navigate to home
      Get.offAllNamed(Routes.HOME);

    } catch (e) {
      Get.snackbar('Error', 'লগইন ব্যর্থ হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ========== Logout ==========
  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _authRepository.logout();
      await _storageService.removeUser();

      currentUser.value = null;
      isLoggedIn.value = false;

      Get.offAllNamed(Routes.LOGIN);

      Get.snackbar('Success', 'লগআউট সফল হয়েছে',
          snackPosition: SnackPosition.BOTTOM);

    } catch (e) {
      Get.snackbar('Error', 'লগআউট ব্যর্থ হয়েছে');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    print('❌ AuthController closed');
    super.onClose();
  }
}