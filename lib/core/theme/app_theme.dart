import 'package:flutter/material.dart';

class AppTheme {
  static const _darkBg = Color(0xFF1A1A2E);
  static const _cardBg = Color(0xFF16213E);
  static const _accent = Color(0xFF0F3460);
  static const _highlight = Color(0xFFE94560);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _darkBg,
        primaryColor: _accent,
        colorScheme: const ColorScheme.dark(
          primary: _accent,
          secondary: _highlight,
          surface: _cardBg,
        ),
        cardColor: _cardBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: _darkBg,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: _cardBg,
          selectedItemColor: _highlight,
          unselectedItemColor: Colors.grey,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      );
}
