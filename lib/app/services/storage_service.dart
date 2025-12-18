import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/models/user_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  // Keys
  static const String _userKey = 'user';
  static const String _tokenKey = 'token';
  static const String _cartKey = 'cart';
  static const String _favoritesKey = 'favorites';
  static const String _themeKey = 'isDarkMode';
  static const String _languageKey = 'language';

  // Initialize
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('✅ StorageService initialized');
    return this;
  }

  // ==================== USER ====================

  Future<void> saveUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    print('✅ User saved: ${user.name}');
  }

  User? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> removeUser() async {
    await _prefs.remove(_userKey);
    await removeToken();
    print('✅ User data removed');
  }

  // ==================== TOKEN ====================

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    print('✅ Token saved');
  }
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }
  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
    print('✅ Token removed');
  }

  // ==================== CART ====================

  Future<void> saveCart(List<CartItem> items) async {
    final cartJson = items.map((item) => item.toJson()).toList();
    await _prefs.setString(_cartKey, jsonEncode(cartJson));
    print('✅ Cart saved: ${items.length} items');
  }

  List<CartItem> getCart() {
    final cartJson = _prefs.getString(_cartKey);
    if (cartJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(cartJson);
        return decoded.map((item) => CartItem.fromJson(item)).toList();
      } catch (e) {
        print('Error loading cart: $e');
      }
    }
    return [];
  }

  Future<void> clearCart() async {
    await _prefs.remove(_cartKey);
    print('✅ Cart cleared');
  }

  // ==================== FAVORITES (Product List) ====================

  Future<void> saveFavorites(List<Product> favorites) async {
    try {
      final favoritesJson = favorites.map((product) => product.toJson()).toList();
      await _prefs.setString(_favoritesKey, jsonEncode(favoritesJson));
      print('✅ Favorites saved: ${favorites.length} items');
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  List<Product> getFavorites() {
    final favoritesJson = _prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(favoritesJson);
        return decoded.map((item) => Product.fromJson(item)).toList();
      } catch (e) {
        print('Error loading favorites: $e');
      }
    }
    return [];
  }

  // ==================== THEME ====================

  Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(_themeKey, isDark);
  }

  bool getThemeMode() {
    return _prefs.getBool(_themeKey) ?? false;
  }

  // ==================== LANGUAGE ====================

  Future<void> saveLanguage(String langCode) async {
    await _prefs.setString(_languageKey, langCode);
  }

  String getLanguage() {
    return _prefs.getString(_languageKey) ?? 'bn';
  }

  // ==================== CLEAR DATA ====================

  Future<void> clearAll() async {
    await _prefs.clear();
    print('✅ All storage cleared');
  }

  Future<void> clearUserData() async {
    await removeUser();
    await removeToken();
    print('✅ User data cleared');
  }
}