import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../data/models/product_model.dart';
import '../modules/cart/controllers/cart_controller.dart';
import '../modules/favorite/controllers/favorite_controller.dart';
import '../core/constants/app_constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final favoriteController = Get.find<FavoriteController>();

    return InkWell(
      onTap: () {
        Get.toNamed('/product-details', arguments: product);
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey[200],
                child: product.image != null && product.image!.isNotEmpty
                    ? Image.network(
                  product.image!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 60, color: Colors.grey),
                )
                    : const Icon(Icons.image, size: 60, color: Colors.grey),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${AppConstants.currency}${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          final isFav = favoriteController.isFavorite(product);
                          return IconButton(
                            iconSize: 26,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey[600],
                            ),
                            onPressed: () => favoriteController.toggleFavorite(product),
                          );
                        }),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton.icon(
                            onPressed: () => cartController.addToCart(product),
                            icon: const Icon(Icons.add_shopping_cart, size: 14),
                            label: const Text('যোগ করুন', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}