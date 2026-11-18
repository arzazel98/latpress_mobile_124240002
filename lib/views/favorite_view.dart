import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../models/show_model.dart';
import '../theme/app_theme.dart';
import 'detail_view.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController controller = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        backgroundColor: context.scaffoldBg,
        elevation: 0,
        title: Text(
          'Daftar Favorit',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: context.textColor,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 40,
                      color: context.textDisabledColor,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Belum Ada Show Favorit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan TV show yang kamu sukai dari halaman Beranda untuk menyimpannya di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textMutedColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.favorites.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final ShowModel show = controller.favorites[index];
            return _buildFavoriteItem(context, show, controller);
          },
        );
      }),
    );
  }

  Widget _buildFavoriteItem(
    BuildContext context,
    ShowModel show,
    FavoriteController controller,
  ) {
    return InkWell(
      onTap: () {
        Get.to(() => DetailView(showId: show.id, initialShow: show));
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.borderColor, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: context.isDarkTheme
                  ? Colors.black.withAlpha(51)
                  : Colors.black.withAlpha(15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 65,
                height: 90,
                child: show.displayImage.isNotEmpty
                    ? Image.network(
                        show.displayImage,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          color: context.elevatedColor,
                          child: Icon(
                            Icons.movie_outlined,
                            color: context.textDisabledColor,
                          ),
                        ),
                      )
                    : Container(
                        color: context.elevatedColor,
                        child: Icon(
                          Icons.movie_outlined,
                          color: context.textDisabledColor,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // Title & Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
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
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    show.genreText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textMutedColor,
                    ),
                  ),
                ],
              ),
            ),

            // Delete Button (Trash Icon)
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFFF334B),
                size: 24,
              ),
              tooltip: 'Hapus dari favorit',
              onPressed: () {
                _confirmDelete(context, show, controller);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    ShowModel show,
    FavoriteController controller,
  ) {
    Get.defaultDialog(
      title: 'Hapus Favorit',
      titleStyle: TextStyle(
        color: context.textColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      middleText: 'Hapus "${show.name}" dari daftar favorit?',
      middleTextStyle: TextStyle(
        color: context.textMutedColor,
        fontSize: 14,
      ),
      backgroundColor: context.surfaceColor,
      radius: 14,
      textCancel: 'Batal',
      cancelTextColor: context.textMutedColor,
      textConfirm: 'Hapus',
      confirmTextColor: Colors.white,
      buttonColor: AppTheme.primaryRed,
      onConfirm: () {
        Get.back(); // close dialog
        controller.deleteFavorite(show);
      },
    );
  }
}
