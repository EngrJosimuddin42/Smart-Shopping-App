import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../controllers/product_details_controller.dart';
import '../../../core/constants/app_constants.dart';

class ProductDetailsPage extends GetView<ProductDetailsController> {
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.product.value?.name ?? 'প্রোডাক্ট ডিটেইলস',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
              color: controller.isFavorite.value ? Colors.red : null,
            ),
            onPressed: controller.toggleFavorite,
          )),
          const SizedBox(width: 8),
        ],
      ),

      body: Obx(() {
        final product = controller.product.value;

        if (product == null) {
          return const Center(
            child: Text('পণ্য পাওয়া যায়নি', style: TextStyle(fontSize: 18)),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 360,
              pinned: true,
              stretch: true,
              automaticallyImplyLeading: false,
              title: const Text(''),
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                stretchModes: const [StretchMode.zoomBackground],
                background: product.image != null && product.image!.isNotEmpty
                    ? Image.network(
                  product.image!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined, size: 80, color: Colors.grey),
                      ),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image_outlined, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // ========== প্রোডাক্ট ডিটেইলস ==========
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 24),
                        const SizedBox(width: 6),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 24),
                        Chip(
                          label: Text(product.category),
                          backgroundColor: Colors.blue[50],
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${AppConstants.currency}${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          product.stock > 0 ? Icons.check_circle : Icons.cancel,
                          color: product.stock > 0 ? Colors.green : Colors.red,
                          size: 26,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          product.stock > 0
                              ? 'স্টকে আছে (${product.stock}টি উপলব্ধ)'
                              : 'স্টক শেষ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: product.stock > 0 ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'বিবরণ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.description ?? 'কোনো বিবরণ দেওয়া হয়নি।',
                      style: const TextStyle(fontSize: 16, height: 1.7, color: Colors.black87),
                    ),
                    const SizedBox(height: 32),
                    _buildQuantitySelector(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      }),

      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildQuantitySelector() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('পরিমাণ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, size: 36, color: Colors.blue),
                  onPressed: controller.decreaseQuantity,
                ),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue[50],
                  ),
                  child: Text(
                    '${controller.quantity.value}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                )),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 36, color: Colors.blue),
                  onPressed: controller.increaseQuantity,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Obx(() {
      final product = controller.product.value;
      if (product == null) return const SizedBox();

      final totalPrice = product.price * controller.quantity.value;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, -6)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('মোট মূল্য', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(
                      '${AppConstants.currency}${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: product.stock > 0 ? controller.addToCart : null,
                  icon: const Icon(Icons.shopping_cart, size: 22),
                  label: const Text('কার্টে যোগ করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: product.stock > 0 ? Colors.blue : Colors.grey[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}