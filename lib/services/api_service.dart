import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show_model.dart';

class TvMazeApiService {
  static const String baseUrl = 'https://api.tvmaze.com';

  /// Mengambil semua daftar TV Show dari endpoint TVMaze
  /// Endpoint: https://api.tvmaze.com/shows
  Future<List<ShowModel>> getShows() async {
    try {
      final uri = Uri.parse('$baseUrl/shows');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => ShowModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Gagal memuat daftar shows (Kode Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat data: $e');
    }
  }

  /// Mengambil detail satu TV Show berdasarkan ID
  /// Endpoint: https://api.tvmaze.com/shows/{id}
  Future<ShowModel> getShowDetail(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/shows/$id');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ShowModel.fromJson(data);
      } else {
        throw Exception(
            'Gagal memuat detail show #$id (Kode Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat detail show: $e');
    }
  }
}
