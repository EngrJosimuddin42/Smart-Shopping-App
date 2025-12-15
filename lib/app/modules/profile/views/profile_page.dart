import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:iconsax/iconsax.dart';
class ProfilePage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('প্রোফাইল'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User info card
            _buildUserCard(),
            SizedBox(height: 16),

            // Settings
            _buildSettingsSection(),
            SizedBox(height: 16),

            // About
            _buildAboutSection(),
            SizedBox(height: 16),

            // Logout button
            _buildLogoutButton(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Obx(() {
      final user = controller.user.value;

      return Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: user != null
                    ? Text(
                  user.name[0].toUpperCase(),
                  style: TextStyle(fontSize: 36, color: Colors.white),
                )
                    : Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                user?.name ?? 'Guest User',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                user?.email ?? 'guest@example.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (user?.phone != null && user!.phone!.isNotEmpty) ...[
                SizedBox(height: 4),
                Text(
                  user.phone!,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
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
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Text('সেটিংস',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Divider(height: 1),

          // Dark mode toggle
          Obx(() => SwitchListTile(
            title: Text('ডার্ক মোড'),
            subtitle: Text('থিম পরিবর্তন করুন'),
            secondary: Icon(Icons.dark_mode),
            value: controller.isDarkMode.value,
            onChanged: controller.toggleDarkMode,
          )),

          // Notifications toggle
          Obx(() => SwitchListTile(
            title: Text('নোটিফিকেশন'),
            subtitle: Text('নোটিফিকেশন চালু/বন্ধ করুন'),
            secondary: Icon(Icons.notifications),
            value: controller.notificationsEnabled.value,
            onChanged: controller.toggleNotifications,
          )),

          ListTile(
            leading: Icon(Icons.language),
            title: Text('ভাষা'),
            subtitle: Obx(() => Text(controller.settings['language'] ?? 'বাংলা')),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.snackbar('Coming Soon', 'ভাষা পরিবর্তন শীঘ্রই আসছে');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Iconsax.info_circle),
            title: const Text('অ্যাপ সম্পর্কে'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App Icon (যদি থাকে)
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(Iconsax.shop, size: 40, color: Colors.blue),
                        ),
                        const SizedBox(height: 20),

                        // App Name
                        const Text(
                          'স্মার্ট শপিং',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Version
                        const Text(
                          'সংস্করণ ১.০.০',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),

                        // Description
                        const Text(
                          'একটি আধুনিক, দ্রুত ও নিরাপদ অনলাইন শপিং অ্যাপ্লিকেশন। '
                              'GetX + Clean Architecture দিয়ে তৈরি করা হয়েছে। '
                              'আপনার কেনাকাটার অভিজ্ঞতা আরও সহজ ও মজাদার করতে আমরা সবসময় কাজ করে যাচ্ছি।',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, height: 1.5),
                        ),
                        const SizedBox(height: 20),

                        // Developer Credit
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
                        const SizedBox(height: 5),
                        const Text(
                          'Flutter Developer',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        const SizedBox(height: 20),

                        // Copyright
                        Text(
                          '© 2025 Smart Shopping. All rights reserved.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),

                        const SizedBox(height: 20),

                        // Close Button
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
                barrierDismissible: true,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('গোপনীয়তা নীতি'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.snackbar('Coming Soon', 'শীঘ্রই আসছে');
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('সাহায্য ও সহায়তা'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.snackbar('Help', 'help@smartshopping.com');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: controller.logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
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
}