import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Profile Picture Circle
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceDark,
                  border: Border.all(
                    color: AppTheme.primaryRed.withAlpha(153),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryRed.withAlpha(51),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 56,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Username from SharedPreferences
            Obx(() => Text(
                  authController.username.value.isNotEmpty
                      ? authController.username.value
                      : '124240002',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                )),
            const SizedBox(height: 4),

            // Class Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withAlpha(38),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryRed.withAlpha(77),
                ),
              ),
              child: const Text(
                'Praktikum Pemrograman Mobile SI-F',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Info Card (NIM & Status)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder, width: 0.8),
              ),
              child: Column(
                children: [
                  _buildProfileRow(
                    icon: Icons.badge_outlined,
                    label: 'NIM Mahasiswa',
                    value: authController.username.value.isNotEmpty
                        ? authController.username.value
                        : '124240002',
                  ),
                  const Divider(color: AppTheme.cardBorder, height: 20),
                  _buildProfileRow(
                    icon: Icons.school_outlined,
                    label: 'Mata Kuliah',
                    value: 'Praktikum Mobile (Responsi)',
                  ),
                  const Divider(color: AppTheme.cardBorder, height: 20),
                  _buildProfileRow(
                    icon: Icons.storage_rounded,
                    label: 'Penyimpanan Sesi',
                    value: 'SharedPreferences (Aktif)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Kesan Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder, width: 0.8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.sentiment_very_satisfied_rounded,
                        color: AppTheme.ratingGold,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Kesan Praktikum',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Praktikum Pemrograman Mobile SI-F sangat seru, menantang, dan aplikatif! Materinya tersusun dengan sangat baik, mulai dari dasar Flutter, state management, konsumsi REST API TVMaze, hingga integrasi database lokal seperti Hive dan SharedPreferences. Banyak ilmu praktis industri yang didapatkan!',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: Color(0xFFC7C7D4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pesan Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder, width: 0.8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: AppTheme.primaryRed,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Pesan Untuk Asisten',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Terima kasih banyak untuk seluruh asisten praktikum atas dedikasi, kesabaran, bimbingan, dan keramahannya selama mendampingi kami. Pesan untuk asisten: Tetap semangat, sukses selalu untuk studi dan kariernya, dan semoga praktikum mobile SI-F ke depannya semakin maju dan keren!',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: Color(0xFFC7C7D4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _confirmLogout(context, authController),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textMuted),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textMuted,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context, AuthController authController) {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      middleText: 'Apakah Anda yakin ingin keluar dari akun ini?',
      middleTextStyle: const TextStyle(
        color: AppTheme.textMuted,
        fontSize: 14,
      ),
      backgroundColor: AppTheme.surfaceElevated,
      radius: 14,
      textCancel: 'Batal',
      cancelTextColor: AppTheme.textMuted,
      textConfirm: 'Ya, Logout',
      confirmTextColor: Colors.white,
      buttonColor: AppTheme.primaryRed,
      onConfirm: () {
        Get.back(); // close dialog
        authController.logout();
      },
    );
  }
}
