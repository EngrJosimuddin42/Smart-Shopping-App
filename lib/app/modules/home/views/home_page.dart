import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import 'package:smart_shopping_app/app/ widgets/product_card.dart';
import '../../../routes/app_routes.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('স্মার্ট শপিং'),
        actions: [
          // Cart Badge
          GetX<CartController>(
            builder: (cart) => Stack(
              children: [
                IconButton(
                  onPressed: () => Get.toNamed('/cart'),
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
                if (cart.cartItems.isNotEmpty)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '${cart.cartItems.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Get.toNamed(Routes.FAVORITE),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(Routes.PROFILE),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategories(),
          Expanded(child: _buildProductsGrid()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'পণ্য খুঁজুন...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) => controller.searchQuery.value = value,
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: Obx(() {
        final categories = controller.categories;
        final selected = controller.selectedCategory.value;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selected == category;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => controller.selectedCategory.value = category,
                selectedColor: Colors.blue,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProductsGrid() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final hasProducts = controller.products.isNotEmpty;
      final filtered = controller.filteredProducts;

      if (isLoading && !hasProducts) {
        return const Center(child: CircularProgressIndicator());
      }

      if (filtered.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('কোনো পণ্য পাওয়া যায়নি', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: filtered.length,
        itemBuilder: (context, index) => ProductCard(product: filtered[index]),
      );
    });
  }
}