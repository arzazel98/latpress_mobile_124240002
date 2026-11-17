import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/show_model.dart';

class HiveService {
  static const String boxName = 'favorite_shows_box';
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  static Box get box => _box;

  /// Memeriksa apakah show dengan id tertentu ada di daftar favorit
  static bool isFavorite(int showId) {
    return _box.containsKey(showId.toString());
  }

  /// Menambahkan show ke favorit (disimpan menggunakan Hive)
  static Future<void> addFavorite(ShowModel show) async {
    try {
      final jsonString = jsonEncode(show.toJson());
      await _box.put(show.id.toString(), jsonString);
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  /// Menghapus show dari favorit
  static Future<void> removeFavorite(int showId) async {
    try {
      await _box.delete(showId.toString());
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  /// Toggle status favorit
  static Future<bool> toggleFavorite(ShowModel show) async {
    if (isFavorite(show.id)) {
      await removeFavorite(show.id);
      return false; // sekarang tidak favorit
    } else {
      await addFavorite(show);
      return true; // sekarang favorit
    }
  }

  /// Mengambil semua daftar show favorit dari Hive
  static List<ShowModel> getFavorites() {
    final List<ShowModel> list = [];
    for (var key in _box.keys) {
      try {
        final rawValue = _box.get(key);
        if (rawValue != null) {
          Map<String, dynamic> map;
          if (rawValue is String) {
            map = jsonDecode(rawValue) as Map<String, dynamic>;
          } else if (rawValue is Map) {
            map = Map<String, dynamic>.from(rawValue);
          } else {
            continue;
          }
          list.add(ShowModel.fromJson(map));
        }
      } catch (e) {
        debugPrint('Error reading item $key: $e');
      }
    }
    return list;
  }
}
