import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_shopping_app/app/core/ utils/snackbar_helper.dart';
class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;

  void sendResetLink() async {
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      SnackbarHelper.showError('সঠিক ইমেইল ঠিকানা দিন');
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    SnackbarHelper.showSuccess('পাসওয়ার্ড রিসেট লিংক ইমেইলে পাঠানো হয়েছে');
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}