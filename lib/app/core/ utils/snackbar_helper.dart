import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  // সফল মেসেজের জন্য
  static void showSuccess(String message) {
    _showSnackbar(
      title: 'সফল',
      message: message,
      backgroundColor: Colors.green.withOpacity(0.1),
      textColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  // এরর মেসেজের জন্য
  static void showError(String message) {
    _showSnackbar(
      title: 'Error',
      message: message,
      backgroundColor: Colors.red.withOpacity(0.1),
      textColor: Colors.red,
      icon: Icons.error_outline,
    );
  }

  // মেইন কমন স্নাকবার মেথড
  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 3),
      titleText: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      messageText: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor),
        ),
      ),
      icon: Icon(icon, color: textColor),
      shouldIconPulse: false,
    );
  }
}