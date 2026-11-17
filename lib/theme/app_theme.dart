import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryRed = Color(0xFFE50914);
  static const Color accentRed = Color(0xFFFF2A42);
  static const Color bgDark = Color(0xFF0C0D14);
  static const Color surfaceDark = Color(0xFF161824);
  static const Color surfaceElevated = Color(0xFF202334);
  static const Color cardBorder = Color(0xFF2B2F44);

  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9E9EB5);
  static const Color textDisabled = Color(0xFF65677E);

  // Status & Accents
  static const Color ratingGold = Color(0xFFFFB800);
  static const Color successGreen = Color(0xFF00E676);

  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    final poppinsTheme = GoogleFonts.poppinsTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: primaryRed,
      colorScheme: const ColorScheme.dark(
        primary: primaryRed,
        secondary: accentRed,
        surface: surfaceDark,
        onPrimary: Colors.white,
        onSurface: textWhite,
      ),
      textTheme: poppinsTheme.copyWith(
        headlineMedium: poppinsTheme.headlineMedium?.copyWith(
          color: textWhite,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        titleLarge: poppinsTheme.titleLarge?.copyWith(
          color: textWhite,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: poppinsTheme.titleMedium?.copyWith(
          color: textWhite,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: poppinsTheme.bodyLarge?.copyWith(
          color: textWhite,
        ),
        bodyMedium: poppinsTheme.bodyMedium?.copyWith(
          color: textMuted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        iconTheme: IconThemeData(color: textWhite),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: cardBorder, width: 0.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: primaryRed.withAlpha(128),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: const TextStyle(color: textDisabled, fontSize: 14),
        labelStyle: const TextStyle(color: textMuted, fontSize: 14),
        prefixIconColor: textMuted,
        suffixIconColor: textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryRed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryRed,
        unselectedItemColor: textDisabled,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
