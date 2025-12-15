import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../core/constants/app_constants.dart';

class CartPage extends GetView<CartController> {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('কার্ট'),
        actions: [
          Obx(() => controller.cartItems.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'কার্ট খালি করুন',
            onPressed: _showClearCartDialog,
          )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart();
        }

        return Column(
          children: [
            Expanded(child: _buildCartItems()),
            _buildCheckoutSection(),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 120, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'আপনার কার্ট খালি',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Text(
              'পছন্দের পণ্য যোগ করুন',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('কেনাকাটা শুরু করুন', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.cartItems.length,
      itemBuilder: (context, index) {
        final item = controller.cartItems[index];

        return Dismissible(
          key: Key(item.product.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white, size: 30),
          ),
          onDismissed: (direction) {
            controller.removeFromCart(item.product.id);
            Get.snackbar(
              'সরানো হয়েছে',
              '${item.product.name} কার্ট থেকে সরানো হয়েছে',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          },
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Product Image (যদি ইমেজ থাকে তাহলে দেখাবে)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.product.image != null && item.product.image!.isNotEmpty
                        ? Image.network(
                      item.product.image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 40, color: Colors.grey),
                      ),
                    )
                        : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${AppConstants.currency}${item.product.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'মোট: ${AppConstants.currency}${item.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  // Quantity Controls
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 28),
                            onPressed: () => controller.decreaseQuantity(item.product.id),
                          ),
                          Container(
                            width: 36,
                            alignment: Alignment.center,
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 28),
                            onPressed: () => controller.increaseQuantity(item.product.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('মোট পণ্য:', style: TextStyle(fontSize: 18)),
                Obx(() => Text(
                  '${controller.itemCount} টি',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('মোট মূল্য:', style: TextStyle(fontSize: 20)),
                Obx(() => Text(
                  '${AppConstants.currency}${controller.totalPrice.value.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                )),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'সফল!',
                    'আপনার অর্ডার গ্রহণ করা হয়েছে!',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                    snackPosition: SnackPosition.TOP,
                  );
                  controller.clearCart();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: const Text('চেকআউট করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('কার্ট খালি করবেন?', textAlign: TextAlign.center),
        content: const Text('সব পণ্য কার্ট থেকে মুছে ফেলা হবে।'),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('বাতিল', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.clearCart();
              Get.snackbar('খালি করা হয়েছে', 'কার্ট থেকে সব পণ্য সরানো হয়েছে');
            },
            child: const Text('হ্যাঁ, খালি করুন', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}