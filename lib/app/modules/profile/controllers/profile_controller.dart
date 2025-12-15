import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../services/storage_service.dart';
import '../../auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthController _authController = Get.find<AuthController>();

  // ========== Reactive Properties ==========
  var user = Rxn<User>();
  var isDarkMode = false.obs;
  var notificationsEnabled = true.obs;

  // ========== Settings Map ==========
  var settings = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    print('✅ ProfileController initialized');

    loadUserData();
    loadSettings();
  }

  void loadUserData() {
    user.value = _storageService.getUser();
  }

  void loadSettings() {
    // Load from storage or use defaults
    settings.value = {
      'language': 'বাংলা',
      'currency': '৳',
      'notifications': true,
      'darkMode': false,
    };
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    settings['darkMode'] = value;

    // Change theme
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    settings['notifications'] = value;
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text('লগআউট'),
        content: Text('আপনি কি লগআউট করতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('না'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _authController.logout();
            },
            child: Text('হ্যাঁ'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    print('❌ ProfileController closed');
    super.onClose();
  }
}