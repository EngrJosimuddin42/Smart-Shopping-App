import 'package:get/get.dart';
import 'package:smart_shopping_app/app/data/models/product_model.dart';
import '../../../services/storage_service.dart';
import 'package:smart_shopping_app/app/core/ utils/snackbar_helper.dart';

class FavoriteController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final favoriteProducts = <Product>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('✅ FavoriteController initialized');
    loadFavorites();
  }

  // Load favorites from storage
  void loadFavorites() {
    favoriteProducts.value = _storageService.getFavorites();
  }

  // Save favorites to storage
  void saveFavorites() {
    _storageService.saveFavorites(favoriteProducts);
  }

  // Toggle Favorite
  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      // পছন্দের তালিকা থেকে মুছে ফেলা
      favoriteProducts.removeWhere((p) => p.id == product.id);
      SnackbarHelper.showError('${product.name} পছন্দের তালিকা থেকে মুছে ফেলা হয়েছে');
    } else {
      // পছন্দের তালিকায় যোগ করা
      favoriteProducts.add(product);
      SnackbarHelper.showSuccess('${product.name} পছন্দের তালিকায় যোগ হয়েছে');
    }

    // লোকাল স্টোরেজে সেভ করা
    saveFavorites();
  }

  // Check if product is in favorites
  bool isFavorite(Product product) {
    return favoriteProducts.any((p) => p.id == product.id);
  }

  @override
  void onClose() {
    print('❌ FavoriteController closed');
    super.onClose();
  }
}