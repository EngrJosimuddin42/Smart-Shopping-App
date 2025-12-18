import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_shopping_app/app/core/ utils/snackbar_helper.dart';


class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('প্রোফাইল'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserCard(),
            const SizedBox(height: 16),
            _buildSettingsSection(),
            const SizedBox(height: 16),
            _buildAboutSection(),
            const SizedBox(height: 16),
            _buildLogoutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Obx(() {
      final user = controller.user.value;

      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: user != null
                    ? Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 36, color: Colors.white),
                )
                    : const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                user?.name ?? 'Guest User',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? 'guest@example.com',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (user?.phone != null && user!.phone!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  user.phone!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSettingsSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const ListTile(
            title: Text('সেটিংস',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),

          // Dark mode toggle
          Obx(() => SwitchListTile(
            title: const Text('ডার্ক মোড'),
            subtitle: const Text('থিম পরিবর্তন করুন'),
            secondary: const Icon(Icons.dark_mode),
            value: controller.isDarkMode.value,
            onChanged: controller.toggleDarkMode,
          )),

          // Notifications toggle
          Obx(() => SwitchListTile(
            title: const Text('নোটিফিকেশন'),
            subtitle: const Text('নোটিফিকেশন চালু/বন্ধ করুন'),
            secondary: const Icon(Icons.notifications),
            value: controller.notificationsEnabled.value,
            onChanged: (value) {
              controller.toggleNotifications(value);
              if(value) {
                SnackbarHelper.showSuccess('নোটিফিকেশন চালু করা হয়েছে');
              } else {
                SnackbarHelper.showError('নোটিফিকেশন বন্ধ করা হয়েছে');
              }
            },
          )),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('ভাষা'),
            subtitle: Obx(() => Text(controller.settings['language'] ?? 'বাংলা')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showSuccess('ভাষা পরিবর্তন শীঘ্রই আসছে');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Iconsax.info_circle),
            title: const Text('অ্যাপ সম্পর্কে'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showAboutDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('গোপনীয়তা নীতি'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showSuccess('গোপনীয়তা নীতি শীঘ্রই আসছে');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('সাহায্য ও সহায়তা'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showSuccess('যোগাযোগ: help@smartshopping.com');
            },
          ),
        ],
      ),
    );
  }

  // কাস্টম অ্যাবাউট ডায়ালগ
  void _showAboutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade50,
                child: const Icon(Iconsax.shop, size: 40, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              const Text(
                'স্মার্ট শপিং',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'সংস্করণ ১.০.০',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                'একটি আধুনিক, দ্রুত ও নিরাপদ অনলাইন শপিং অ্যাপ্লিকেশন। '
                    'GetX + Clean Architecture দিয়ে তৈরি করা হয়েছে।',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'তৈরি করেছেন',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Text(
                'জসিম উদ্দিন',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    'ঠিক আছে',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            _showLogoutConfirmation();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout),
              SizedBox(width: 8),
              Text('লগআউট', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    Get.defaultDialog(
      title: 'লগআউট',
      middleText: 'আপনি কি নিশ্চিতভাবে লগআউট করতে চান?',
      textConfirm: 'হ্যাঁ',
      textCancel: 'না',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.logout();
      },
    );
  }
}