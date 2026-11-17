import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/show_model.dart';
import '../services/hive_service.dart';

class FavoriteController extends GetxController {
  final RxList<ShowModel> favorites = <ShowModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    favorites.assignAll(HiveService.getFavorites());
  }

  bool isFavorite(int showId) {
    return favorites.any((show) => show.id == showId);
  }

  Future<void> toggleFavorite(ShowModel show) async {
    final nowFav = await HiveService.toggleFavorite(show);
    loadFavorites();

    if (nowFav) {
      Get.snackbar(
        'Ditambahkan ke Favorit',
        '${show.name} berhasil disimpan ke daftar favorit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E2235),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite, color: Color(0xFFE50914)),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Dihapus dari Favorit',
        '${show.name} dihapus dari daftar favorit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E2235),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Colors.grey),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> deleteFavorite(ShowModel show) async {
    await HiveService.removeFavorite(show.id);
    loadFavorites();

    Get.snackbar(
      'Dihapus',
      '${show.name} telah dihapus dari daftar favorit.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E2235),
      colorText: Colors.white,
      icon: const Icon(Icons.delete_outline, color: Color(0xFFFF2A42)),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
}
