import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import 'package:smart_shopping_app/app/core/ utils/snackbar_helper.dart';


class HomeController extends GetxController {
  final ProductRepository _productRepository = ProductRepository();

  // ========== Reactive Properties ==========
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var favoriteIds = <String>{}.obs;

  // ========== Non-Reactive Properties ==========
  final List<String> categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home',
    'Books',
  ];

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    print('✅ HomeController initialized');
    loadProducts();
    setupListeners();
    _startAutoRefresh();
  }

  @override
  void onReady() {
    super.onReady();
    print('✅ HomeController ready - View rendered');
  }

  // রিঅ্যাক্টিভ লিসনার সেটআপ
  void setupListeners() {
    debounce(searchQuery, (_) => filterProducts(),
        time: const Duration(milliseconds: 500));
    ever(selectedCategory, (_) => filterProducts());
    once(products, (_) {
      if (products.isNotEmpty) {
        SnackbarHelper.showSuccess('${products.length}টি পণ্য লোড হয়েছে');
      }
    });
  }

  // প্রোডাক্ট লোড করা
  Future<void> loadProducts() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      final fetchedProducts = await _productRepository.getAllProducts();
      products.assignAll(fetchedProducts);
      filterProducts();

    } catch (e) {
      print('Error loading products: $e');
      SnackbarHelper.showError('পণ্য লোড করতে সমস্যা হয়েছে');
    } finally {
      isLoading.value = false;
    }
  }

  // ফিল্টার লজিক
  void filterProducts() {
    List<Product> temp = products.toList();

    if (selectedCategory.value != 'All') {
      temp = temp.where((p) => p.category == selectedCategory.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      temp = temp.where((p) {
        return p.name.toLowerCase().contains(query) ||
            (p.description ?? '').toLowerCase().contains(query);
      }).toList();
    }

    filteredProducts.assignAll(temp);
  }

  // ========== Favorite Methods ==========
  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
      SnackbarHelper.showError('প্রোডাক্ট ফেভারিট থেকে সরানো হয়েছে');
    } else {
      favoriteIds.add(productId);
      SnackbarHelper.showSuccess('প্রোডাক্ট ফেভারিটে যোগ হয়েছে');
    }
  }

  // অটো রিফ্রেশ
  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      print('🔄 Auto refreshing products...');
      loadProducts();
    });
  }

  // ম্যানুয়াল রিফ্রেশ
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  @override
  void onClose() {
    print('❌ HomeController closed');
    _refreshTimer?.cancel();
    super.onClose();
  }
}