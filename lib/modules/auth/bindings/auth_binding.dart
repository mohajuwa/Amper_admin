// lib/modules/auth/bindings/auth_binding.dart
import 'package:ecom_modwir/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Bind AuthController, making it available for LoginScreen and potentially elsewhere
    // Use fenix: true if you want it to be recreated if disposed, but usually for auth, permanent might be better if managed carefully or just lazyPut.
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
