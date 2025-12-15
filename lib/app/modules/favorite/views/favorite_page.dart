import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import 'package:smart_shopping_app/app/ widgets/product_card.dart';

class FavoritePage extends GetView<FavoriteController> {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পছন্দের তালিকা'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.favoriteProducts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text('কোনো পছন্দের পণ্য নেই', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.favoriteProducts.length,
          itemBuilder: (context, index) {
            final product = controller.favoriteProducts[index];
            return ProductCard(product: product);
          },
        );
      }),
    );
  }
}