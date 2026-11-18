import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../models/show_model.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class DetailView extends StatefulWidget {
  final int showId;
  final ShowModel? initialShow;

  const DetailView({
    super.key,
    required this.showId,
    this.initialShow,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final TvMazeApiService _apiService = TvMazeApiService();
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

  ShowModel? _show;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _show = widget.initialShow;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = _show == null;
      _errorMessage = null;
    });

    try {
      final fetchedShow = await _apiService.getShowDetail(widget.showId);
      if (mounted) {
        setState(() {
          _show = fetchedShow;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _show == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryRed),
        ),
      );
    }

    if (_errorMessage != null && _show == null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 64,
                  color: context.textMutedColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat detail show',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.textMutedColor,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _fetchDetail,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Kembali',
                    style: TextStyle(color: context.textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final show = _show!;

    return CustomScrollView(
      slivers: [
        // App Bar with Hero Image and Back Button
        SliverAppBar(
          expandedHeight: 380.0,
          pinned: true,
          backgroundColor: context.scaffoldBg,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0x8C000000),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          actions: [
            Obx(() {
              final isFav = _favoriteController.isFavorite(show.id);
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0x8C000000),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFav ? AppTheme.primaryRed : Colors.white,
                  ),
                  onPressed: () => _favoriteController.toggleFavorite(show),
                ),
              );
            }),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                show.displayImage.isNotEmpty
                    ? Image.network(
                        show.displayImage,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          color: context.surfaceColor,
                          child: Center(
                            child: Icon(
                              Icons.movie_creation_outlined,
                              size: 72,
                              color: context.textMutedColor,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: context.surfaceColor,
                        child: Center(
                          child: Icon(
                            Icons.movie_creation_outlined,
                            size: 72,
                            color: context.textMutedColor,
                          ),
                        ),
                      ),

                // Gradient Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          context.scaffoldBg.withAlpha(128),
                          context.scaffoldBg,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Show Content Details
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  show.name,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: context.textColor,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Rating & Metadata Row
                Row(
                  children: [
                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.ratingGold.withAlpha(46),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.ratingGold.withAlpha(128),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: AppTheme.ratingGold,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            show.ratingText,
                            style: const TextStyle(
                              color: AppTheme.ratingGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Premiered Year
                    if (show.premieredYear.isNotEmpty) ...[
                      Text(
                        show.premieredYear,
                        style: TextStyle(
                          color: context.textMutedColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '•',
                        style: TextStyle(color: context.textDisabledColor),
                      ),
                      const SizedBox(width: 10),
                    ],

                    // Runtime
                    if (show.runtime != null) ...[
                      Text(
                        '${show.runtime} Menit',
                        style: TextStyle(
                          color: context.textMutedColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '•',
                        style: TextStyle(color: context.textDisabledColor),
                      ),
                      const SizedBox(width: 10),
                    ],

                    // Status Badge
                    if (show.status != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: context.elevatedColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          show.status!,
                          style: TextStyle(
                            fontSize: 11,
                            color: context.textColor.withAlpha(200),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Genre Chips
                if (show.genres.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: show.genres.map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: context.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          genre,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Action Buttons Row: Nonton & Favorit
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.snackbar(
                            'Streaming Series',
                            'Memulai pemutaran episode untuk "${show.name}"...',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: context.surfaceColor,
                            colorText: context.textColor,
                            icon: const Icon(
                              Icons.play_circle_fill_rounded,
                              color: AppTheme.primaryRed,
                            ),
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 24),
                        label: const Text(
                          'Nonton',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryRed,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(() {
                      final isFav = _favoriteController.isFavorite(show.id);
                      return OutlinedButton.icon(
                        onPressed: () =>
                            _favoriteController.toggleFavorite(show),
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? AppTheme.primaryRed : context.textColor,
                        ),
                        label: Text(
                          isFav ? 'Favorit' : 'Tambah',
                          style: TextStyle(
                            color:
                                isFav ? AppTheme.primaryRed : context.textColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          side: BorderSide(
                            color: isFav
                                ? AppTheme.primaryRed
                                : context.borderColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: context.surfaceColor,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 24),

                // Overview Header
                Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),

                // Overview Content
                Text(
                  show.cleanSummary,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: context.isDarkTheme
                        ? const Color(0xFFC7C7D4)
                        : const Color(0xFF4A4D62),
                  ),
                ),
                const SizedBox(height: 28),

                // Additional Info Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                          context, 'Bahasa', show.language ?? 'English'),
                      Divider(color: context.borderColor, height: 18),
                      _buildInfoRow(
                          context, 'Status Penayangan', show.status ?? '-'),
                      Divider(color: context.borderColor, height: 18),
                      _buildInfoRow(
                        context,
                        'Rilis Perdana',
                        show.premiered ?? '-',
                      ),
                      if (show.officialSite != null) ...[
                        Divider(color: context.borderColor, height: 18),
                        _buildInfoRow(
                            context, 'Situs Resmi', show.officialSite!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.textMutedColor,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: context.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
