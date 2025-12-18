import 'package:get/get.dart';
import 'package:smart_shopping_app/app/modules/auth/bindings/forgot_password_binding.dart';
import 'package:smart_shopping_app/app/modules/auth/views/forgot_password_page.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/auth/views/signup_page.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_page.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_page.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/views/product_details_page.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_page.dart';
import '../modules/favorite/bindings/favorite_binding.dart';
import '../modules/favorite/views/favorite_page.dart';
import 'app_routes.dart';


class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignupPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordPage(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.FAVORITE,
      page: () => const FavoritePage(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: Routes.PRODUCT_DETAILS,
      page: () => ProductDetailsPage(),
      binding: ProductDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.CART,
      page: () => CartPage(),
      binding: CartBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}