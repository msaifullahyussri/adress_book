import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);

  //  (Light Theme) - #56146C
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF56146C),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF56146C)),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF56146C),
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFC4C4C4),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF56146C),
      unselectedItemColor: Colors.grey,
    ),
  );

  // (Dark Theme) - #9DACFF
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF9DACFF),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9DACFF),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF9DACFF),
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF9DACFF),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFF9DACFF),
      unselectedItemColor: Colors.grey,
    ),
  );

  /// Toggle theme antara Light dan Dark
  void toggleTheme(bool isDark) {
    emit(isDark ? _darkTheme : _lightTheme);
  }
}
