import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/models/product_model.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/product_repository.dart';

class ApiService extends GetxService {
  final ProductRepository productRepository = ProductRepository();
  final AuthRepository authRepository = AuthRepository();

  // Get products
  Future<List<Product>> getProducts() async {
    return await productRepository.getAllProducts();
  }

  // Login
  Future<User> login(String email, String password) async {
    return await authRepository.login(email, password);
  }
}