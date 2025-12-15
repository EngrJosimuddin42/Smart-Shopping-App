import 'package:get/Get.dart';
import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';  // শুধু এটা রাখো, HomeController রিমুভ করো

class ProductDetailsController extends GetxController {
  final CartController _cartController = Get.find<CartController>();
  final FavoriteController _favoriteController = Get.find<FavoriteController>();  // শুধু এটা ব্যবহার করো

  var product = Rxn<Product>();
  var quantity = 1.obs;
  var isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('✅ ProductDetailsController initialized');

    if (Get.arguments != null && Get.arguments is Product) {
      product.value = Get.arguments as Product;
      _checkIfFavorite();
    }
  }

  void _checkIfFavorite() {
    if (product.value != null) {
      isFavorite.value = _favoriteController.isFavorite(product.value!);  // FavoriteController থেকে চেক
    }
  }

  void increaseQuantity() {
    if (product.value != null && quantity.value < product.value!.stock) {
      quantity++;
    } else {
      Get.snackbar('Stock Limit', 'স্টকে আর নেই', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity--;
    }
  }

  void addToCart() {
    if (product.value != null) {
      for (int i = 0; i < quantity.value; i++) {
        _cartController.addToCart(product.value!);
      }

      Get.snackbar(
        'Success',
        '${quantity.value}টি ${product.value!.name} কার্টে যোগ হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      quantity.value = 1;
    }
  }

  void toggleFavorite() {
    if (product.value != null) {
      _favoriteController.toggleFavorite(product.value!);  // শুধু FavoriteController ব্যবহার করো
      isFavorite.value = !isFavorite.value;  // UI আপডেটের জন্য
    }
  }

  @override
  void onClose() {
    print('❌ ProductDetailsController closed');
    super.onClose();
  }
}