import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String keyIsDarkMode = 'is_dark_mode_pref';
  final RxBool isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeFromPrefs();
  }

  Future<void> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // Default adalah mode gelap (true) sesuai tema bioskop awal
    isDarkMode.value = prefs.getBool(keyIsDarkMode) ?? true;
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsDarkMode, isDarkMode.value);

    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    Get.snackbar(
      isDarkMode.value ? 'Mode Gelap Aktif' : 'Mode Terang Aktif',
      isDarkMode.value
          ? 'Tampilan beralih ke Dark Cinema Mode.'
          : 'Tampilan beralih ke Light Mode.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: isDarkMode.value
          ? const Color(0xFF1E2235)
          : const Color(0xFFFFFFFF),
      colorText: isDarkMode.value ? Colors.white : const Color(0xFF161824),
      icon: Icon(
        isDarkMode.value ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        color: isDarkMode.value ? Colors.amber : const Color(0xFFE50914),
      ),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}
