import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';
import 'package:smart_shopping_app/app/core/ utils/snackbar_helper.dart';


class ProductDetailsController extends GetxController {
  final CartController _cartController = Get.find<CartController>();
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

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
      isFavorite.value = _favoriteController.isFavorite(product.value!);
    }
  }

  void increaseQuantity() {
    if (product.value != null && quantity.value < product.value!.stock) {
      quantity++;
    } else {
      SnackbarHelper.showError('দুঃখিত, স্টকে আর পণ্য নেই');
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity--;
    }
  }

  void addToCart() {
    if (product.value != null) {
      // কার্ট কন্ট্রোলারে পণ্য যোগ করা হচ্ছে
      for (int i = 0; i < quantity.value; i++) {
        _cartController.addToCart(product.value!);
      }
      SnackbarHelper.showSuccess(
        '${quantity.value}টি ${product.value!.name} কার্টে যোগ হয়েছে',
      );

      // পণ্য যোগ করার পর কোয়ান্টিটি রিসেট
      quantity.value = 1;
    }
  }

  void toggleFavorite() {
    if (product.value != null) {
      _favoriteController.toggleFavorite(product.value!);
      // ফেভারিট স্ট্যাটাস আপডেট করা
      isFavorite.value = !isFavorite.value;
    }
  }

  @override
  void onClose() {
    print('❌ ProductDetailsController closed');
    super.onClose();
  }
}