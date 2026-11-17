import 'package:get/get.dart';
import '../models/show_model.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final TvMazeApiService _apiService = TvMazeApiService();

  final RxList<ShowModel> shows = <ShowModel>[].obs;
  final RxList<ShowModel> filteredShows = <ShowModel>[].obs;
  final RxList<String> availableGenres = <String>['All'].obs;

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedGenre = 'All'.obs;
  final Rx<ShowModel?> featuredShow = Rx<ShowModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchShows();
  }

  Future<void> fetchShows() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _apiService.getShows();
      shows.assignAll(result);

      // Collect unique genres
      final Set<String> genresSet = {'All'};
      for (var show in result) {
        genresSet.addAll(show.genres);
      }
      availableGenres.assignAll(genresSet.toList());

      // Pick a featured show with rating >= 8.5 or the first one
      if (result.isNotEmpty) {
        featuredShow.value = result.firstWhere(
          (s) => (s.rating ?? 0) >= 8.5,
          orElse: () => result.first,
        );
      }

      applyFilters();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void onGenreSelected(String genre) {
    selectedGenre.value = genre;
    applyFilters();
  }

  void applyFilters() {
    List<ShowModel> temp = List.from(shows);

    // Filter by genre
    if (selectedGenre.value != 'All') {
      temp = temp
          .where((s) => s.genres.contains(selectedGenre.value))
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.trim().isNotEmpty) {
      final q = searchQuery.value.toLowerCase().trim();
      temp = temp
          .where((s) =>
              s.name.toLowerCase().contains(q) ||
              s.genres.any((g) => g.toLowerCase().contains(q)))
          .toList();
    }

    filteredShows.assignAll(temp);
  }
}
