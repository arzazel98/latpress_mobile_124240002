import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../theme/app_theme.dart';
import 'favorite_view.dart';
import 'home_view.dart';
import 'profile_view.dart';

class MainNavView extends StatefulWidget {
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    FavoriteView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.put(FavoriteController());

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          border: Border(
            top: BorderSide(color: context.borderColor, width: 0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: context.isDarkTheme
                  ? Colors.black.withAlpha(50)
                  : Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: context.surfaceColor,
          currentIndex: _currentIndex,
          selectedItemColor: AppTheme.primaryRed,
          unselectedItemColor: context.textDisabledColor,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // If switching to favorite page, reload favorites
            if (index == 1) {
              favoriteController.loadFavorites();
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Obx(() {
                final count = favoriteController.favorites.length;
                if (count > 0) {
                  return Badge(
                    label: Text(count.toString()),
                    backgroundColor: AppTheme.primaryRed,
                    child: const Icon(Icons.favorite_border_rounded),
                  );
                }
                return const Icon(Icons.favorite_border_rounded);
              }),
              activeIcon: Obx(() {
                final count = favoriteController.favorites.length;
                if (count > 0) {
                  return Badge(
                    label: Text(count.toString()),
                    backgroundColor: AppTheme.primaryRed,
                    child: const Icon(Icons.favorite_rounded),
                  );
                }
                return const Icon(Icons.favorite_rounded);
              }),
              label: 'Favorit',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
