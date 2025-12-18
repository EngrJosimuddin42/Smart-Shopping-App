import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';
import '../../../services/storage_service.dart';
import 'package:smart_shopping_app/app/core/ utils/snackbar_helper.dart';

class CartController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // ========== Reactive Properties ==========
  var cartItems = <CartItem>[].obs; // RxList
  var totalPrice = 0.0.obs; // RxDouble
  var itemCount = 0.obs; // RxInt

  @override
  void onInit() {
    super.onInit();
    print('✅ CartController initialized');

    loadCart();

    // cartItems পরিবর্তন হলে অটোমেটিক টোটাল ক্যালকুলেট এবং সেভ হবে
    ever(cartItems, (_) {
      calculateTotal();
      saveCart();
    });
  }

  // Load cart from storage
  void loadCart() {
    cartItems.value = _storageService.getCart();
    calculateTotal();
  }

  // Save cart to storage
  void saveCart() {
    _storageService.saveCart(cartItems);
  }

  // Add to cart
  void addToCart(Product product) {
    final existingIndex = cartItems.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // পরিমাণ বাড়ানো
      cartItems[existingIndex].quantity++;
      cartItems.refresh();
    } else {
      // নতুন আইটেম যোগ করা
      cartItems.add(CartItem(product: product, quantity: 1));
    }
    SnackbarHelper.showSuccess('${product.name} কার্টে যোগ হয়েছে');
  }

  // Remove from cart
  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    SnackbarHelper.showError('কার্ট থেকে মুছে ফেলা হয়েছে');
  }

  // Increase quantity
  void increaseQuantity(String productId) {
    final index = cartItems.indexWhere(
          (item) => item.product.id == productId,
    );
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    }
  }

  // Decrease quantity
  void decreaseQuantity(String productId) {
    final index = cartItems.indexWhere(
          (item) => item.product.id == productId,
    );

    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        removeFromCart(productId);
      }
    }
  }

  // Calculate total
  void calculateTotal() {
    double total = 0;
    int count = 0;

    for (var item in cartItems) {
      total += item.totalPrice;
      count += item.quantity;
    }

    totalPrice.value = total;
    itemCount.value = count;
  }

  // Clear cart
  void clearCart() {
    if (cartItems.isNotEmpty) {
      cartItems.clear();
      SnackbarHelper.showSuccess('কার্ট খালি করা হয়েছে');
    }
  }

  @override
  void onClose() {
    print('❌ CartController closed');
    super.onClose();
  }
}