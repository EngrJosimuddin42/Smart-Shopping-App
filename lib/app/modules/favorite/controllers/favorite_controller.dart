import 'package:get/get.dart';
import 'package:smart_shopping_app/app/data/models/product_model.dart';
import '../../../services/storage_service.dart';

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

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      favoriteProducts.removeWhere((p) => p.id == product.id);
      Get.snackbar(
        'Removed',
        '${product.name} পছন্দের তালিকা থেকে মুছে ফেলা হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
    } else {
      favoriteProducts.add(product);
      Get.snackbar(
        'Added',
        '${product.name} পছন্দের তালিকায় যোগ হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
    }
    saveFavorites(); // Save after toggle
  }

  bool isFavorite(Product product) {
    return favoriteProducts.any((p) => p.id == product.id);
  }

  @override
  void onClose() {
    print('❌ FavoriteController closed');
    super.onClose();
  }
}