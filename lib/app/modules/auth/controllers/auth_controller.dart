import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_routes.dart';
import 'package:smart_shopping_app/app/core/ utils/snackbar_helper.dart';

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

  // স্টোরেজ থেকে লগইন স্ট্যাটাস চেক করা
  void checkLoginStatus() {
    final user = _storageService.getUser();
    final token = _storageService.getToken();

    if (user != null && token != null) {
      currentUser.value = user;
      isLoggedIn.value = true;
      print('🔑 User logged in with token: $token');
    }
  }

  // পাসওয়ার্ড দেখানো বা লুকানোর ফাংশন
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
    // ভ্যালিডেশন চেক
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      SnackbarHelper.showError('সব ফিল্ড পূরণ করুন');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      SnackbarHelper.showError('সঠিক ইমেইল দিন');
      return;
    }

    if (password.length < 6) {
      SnackbarHelper.showError('পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে');
      return;
    }

    if (password != confirmPassword) {
      SnackbarHelper.showError('পাসওয়ার্ড মিলছে না');
      return;
    }

    try {
      isLoading.value = true;

      // ১. রিপোজিটরি থেকে সাইনআপ কল করা
      final user = await _authRepository.signUp(name, email, password);

      // ২. টোকেন সেভ করা
      if (user.token != null) {
        await _storageService.saveToken(user.token!);
      }

      // ৩. ইউজার ডেটা সেভ করা
      await _storageService.saveUser(user);
      currentUser.value = user;
      isLoggedIn.value = true;

      // সাকসেস স্নাকবার
      SnackbarHelper.showSuccess('একাউন্ট তৈরি সফল হয়েছে! 🎉');

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      SnackbarHelper.showError(e.toString().replaceAll('Exception:', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ========== Login ==========
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      SnackbarHelper.showError('সব ফিল্ড পূরণ করুন');
      return;
    }
    try {
      isLoading.value = true;

      // ১. লগইন কল
      final user = await _authRepository.login(email, password);

      // ২. রিয়েল টোকেন সেভ করা
      if (user.token != null) {
        await _storageService.saveToken(user.token!);
      }

      // ৩. ইউজার ডেটা সেভ
      await _storageService.saveUser(user);

      currentUser.value = user;
      isLoggedIn.value = true;

      // সাকসেস স্নাকবার
      SnackbarHelper.showSuccess('লগইন সফল হয়েছে!');

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      SnackbarHelper.showError(e.toString().replaceAll('Exception:', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ========== Logout ==========
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // সার্ভারকে লগআউটের অনুরোধ পাঠানো
      await _authRepository.logout();

      // লোকাল স্টোরেজ থেকে সব মুছে ফেলা
      await _storageService.clearUserData();

      currentUser.value = null;
      isLoggedIn.value = false;

      Get.offAllNamed(Routes.LOGIN);
      SnackbarHelper.showSuccess('লগআউট সফল হয়েছে');
    } catch (e) {
      await _storageService.clearUserData();
      Get.offAllNamed(Routes.LOGIN);
      SnackbarHelper.showError('লগআউট করার সময় সমস্যা হয়েছে');
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