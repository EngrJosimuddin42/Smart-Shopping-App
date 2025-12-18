import '../models/product_model.dart';
import '../providers/api_provider.dart';

class ProductRepository {
  final ApiProvider apiProvider = ApiProvider();

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      // Mock data
      return _getMockProducts();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
  // Get product by ID
  Future<Product> getProductById(String id) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return _getMockProducts().firstWhere((p) => p.id == id);
    } catch (e) {
      throw Exception('Product not found: $e');
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return _getMockProducts()
          .where((p) => p.category == category)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch category products: $e');
    }
  }

  // Mock products
  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'Sony WH-1000XM5',
        description: 'নয়েজ ক্যান্সেলিং হেডফোন',
        price: 32000,
        image: 'https://cdn.mos.cms.futurecdn.net/skBVreU5KroYycebb5Kqa9.jpg',
        category: 'Electronics',
        rating: 4.8,
        stock: 75,
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24',
        description: 'সর্বশেষ স্যামসাং ফ্ল্যাগশিপ ফোন',
        price: 89999,
        image: 'https://m.media-amazon.com/images/I/41RiSZxNR5L.jpg',
        category: 'Electronics',
        rating: 4.5,
        stock: 50,
      ),
      Product(
        id: '3',
        name: 'MacBook Pro M3',
        description: 'শক্তিশালী ল্যাপটপ',
        price: 245000,
        image: 'https://s.yimg.com/uu/api/res/1.2/JaIX6rWrdx5q3ixlN4ke7w--~B/Zmk9c3RyaW07aD03MjA7dz0xMjgwO2FwcGlkPXl0YWNoeW9u/https://s.yimg.com/os/creatr-uploaded-images/2023-10/644c0b40-77e7-11ee-babf-8e883513c64f',
        category: 'Electronics',
        rating: 4.9,
        stock: 25,
      ),
      Product(
        id: '4',
        name: 'Nike Air Max',
        description: 'আরামদায়ক স্পোর্টস জুতা',
        price: 8500,
        image: 'https://media.gq.com/photos/688bce611fa0e61d94141fed/master/w_1600%2Cc_limit/Nike-Air-Max-95-SP-A-Ma-Maniere-While-You-Were-Sleeping-Product.png',
        category: 'Fashion',
        rating: 4.7,
        stock: 100,
      ),
      Product(
        id: '5',
        name: 'Levi\'s Jeans',
        description: 'ক্লাসিক ডেনিম জিন্স',
        price: 3500,
        image: 'https://cdn11.bigcommerce.com/s-tr3jb3z4ny/images/stencil/1280x1280/products/10775/23471/125010537-front-pdp-bcm__23518.1721082140.jpg?c=1',
        category: 'Fashion',
        rating: 4.3,
        stock: 200,
      ),
    ];
  }
}