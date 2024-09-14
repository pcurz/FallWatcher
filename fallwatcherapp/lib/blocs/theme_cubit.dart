import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppThemes.lightTheme);

  void toggleTheme(bool isDark) {
    emit(isDark ? AppThemes.darkTheme : AppThemes.lightTheme);
  }
}

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      error: Colors.red, // Color para errores
      onError: Colors.white, // Color del texto sobre el color de error
    ),
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.blueAccent),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      error: Colors.redAccent, // Color de error en tema oscuro
      onError: Colors.black, // Color del texto sobre el color de error
    ),
    cardColor: Colors.grey[800],
    iconTheme: const IconThemeData(color: Colors.blueAccent),
  );
}
