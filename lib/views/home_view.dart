import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/show_model.dart';
import '../theme/app_theme.dart';
import 'detail_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        backgroundColor: context.scaffoldBg,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Skuy Nonton!',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: context.textColor,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        actions: [
          // Theme Toggle Button (Light/Dark Mode)
          Obx(() {
            final isDark = themeController.isDarkMode.value;
            return IconButton(
              tooltip:
                  isDark ? 'Ganti ke Mode Terang' : 'Ganti ke Mode Gelap',
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDark ? AppTheme.ratingGold : AppTheme.primaryRed,
              ),
              onPressed: () => themeController.toggleTheme(),
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryRed,
        backgroundColor: context.surfaceColor,
        onRefresh: () => controller.fetchShows(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryRed),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat TV Shows...',
                    style: TextStyle(
                      color: context.textMutedColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: AppTheme.primaryRed,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oops, terjadi kendala koneksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textMutedColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => controller.fetchShows(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Search Bar & Filter Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Input Field
                      TextField(
                        onChanged: controller.onSearchChanged,
                        style: TextStyle(
                          color: context.textColor,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari judul serial atau genre...',
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: context.textMutedColor,
                          ),
                          suffixIcon: controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () =>
                                      controller.onSearchChanged(''),
                                )
                              : null,
                          fillColor: context.surfaceColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Genre Chips Scroll
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.availableGenres.length,
                          separatorBuilder: (ctx, i) =>
                              const SizedBox(width: 8),
                          itemBuilder: (ctx, index) {
                            final genre = controller.availableGenres[index];
                            final isSelected =
                                controller.selectedGenre.value == genre;

                            return ChoiceChip(
                              label: Text(genre),
                              selected: isSelected,
                              onSelected: (_) =>
                                  controller.onGenreSelected(genre),
                              selectedColor: AppTheme.primaryRed,
                              backgroundColor: context.surfaceColor,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : context.textMutedColor,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppTheme.primaryRed
                                      : context.borderColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Hero Banner (Only shown when not searching)
              if (controller.searchQuery.value.isEmpty &&
                  controller.selectedGenre.value == 'All' &&
                  controller.featuredShow.value != null)
                SliverToBoxAdapter(
                  child: _buildFeaturedBanner(
                    context,
                    controller.featuredShow.value!,
                  ),
                ),

              // Title Section: Daftar Series
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Semua Series Populer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.textColor,
                        ),
                      ),
                      Text(
                        '${controller.filteredShows.length} Shows',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.textMutedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Empty Search Result
              if (controller.filteredShows.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 48, horizontal: 24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: context.textDisabledColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada series yang ditemukan',
                            style: TextStyle(
                              color: context.textMutedColor,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                // Grid of Shows
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final show = controller.filteredShows[index];
                        return _buildShowCard(context, show);
                      },
                      childCount: controller.filteredShows.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFeaturedBanner(BuildContext context, ShowModel show) {
    return GestureDetector(
      onTap: () => Get.to(() => DetailView(showId: show.id, initialShow: show)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
          image: show.displayImage.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(show.displayImage),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                )
              : null,
          color: context.surfaceColor,
        ),
        child: Stack(
          children: [
            // Dark Gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0x80000000),
                      Color(0xEB000000),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.2, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            // Content
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'PILIHAN TERBAIK',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    show.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppTheme.ratingGold,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        show.ratingText,
                        style: const TextStyle(
                          color: AppTheme.ratingGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        show.genreText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFD4D4E0),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowCard(BuildContext context, ShowModel show) {
    return GestureDetector(
      onTap: () => Get.to(() => DetailView(showId: show.id, initialShow: show)),
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.borderColor, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: context.isDarkTheme
                  ? Colors.black.withAlpha(77)
                  : Colors.black.withAlpha(18),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Image + Rating Badge
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    show.displayImage.isNotEmpty
                        ? Image.network(
                            show.displayImage,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              color: context.elevatedColor,
                              child: Center(
                                child: Icon(
                                  Icons.movie_outlined,
                                  color: context.textDisabledColor,
                                  size: 36,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: context.elevatedColor,
                            child: Center(
                              child: Icon(
                                Icons.movie_outlined,
                                color: context.textDisabledColor,
                                size: 36,
                              ),
                            ),
                          ),

                    // Top Rating Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xC0000000),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.ratingGold.withAlpha(128),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppTheme.ratingGold,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              show.ratingText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title & Genre Info
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      show.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      show.genres.isNotEmpty ? show.genres.first : 'Series',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.textMutedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
