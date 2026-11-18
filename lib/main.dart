import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';
import 'services/auth_service.dart';
import 'services/hive_service.dart';
import 'theme/app_theme.dart';
import 'views/login_view.dart';
import 'views/main_nav_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Storage Lokal (Hive & SharedPreferences)
  await HiveService.init();
  await AuthService.init();

  // Inisialisasi ThemeController
  final themeController = Get.put(ThemeController());
  await themeController.loadThemeFromPrefs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengecek apakah user sudah memiliki sesi login aktif
    final bool initialLoggedIn = AuthService.isLoggedIn;
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'NontonSkuy - TV Series',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        home: initialLoggedIn ? const MainNavView() : const LoginView(),
      ),
    );
  }
}
