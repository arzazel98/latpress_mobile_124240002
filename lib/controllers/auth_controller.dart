import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../views/login_view.dart';
import '../views/main_nav_view.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxString username = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    isLoggedIn.value = AuthService.isLoggedIn;
    username.value = AuthService.username;
  }

  Future<void> login(String inputNim, String inputPassword) async {
    isLoading.value = true;
    // Simulate slight network delay for smooth UX
    await Future.delayed(const Duration(milliseconds: 400));

    final success = await AuthService.login(inputNim, inputPassword);
    isLoading.value = false;

    if (success) {
      isLoggedIn.value = true;
      username.value = AuthService.username;
      Get.snackbar(
        'Login Berhasil',
        'Selamat datang kembali, ${AuthService.username}!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1E2235),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Color(0xFF00E676)),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      Get.offAll(() => const MainNavView());
    } else {
      Get.snackbar(
        'Login Gagal',
        'Username harus ${AuthService.requiredNim} dan Password adalah ${AuthService.requiredPassword}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF381519),
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Color(0xFFFF2A42)),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    isLoggedIn.value = false;
    username.value = '';
    Get.snackbar(
      'Logout Berhasil',
      'Session Anda telah dihapus.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E2235),
      colorText: Colors.white,
      icon: const Icon(Icons.logout, color: Colors.amber),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
    Get.offAll(() => const LoginView());
  }
}
