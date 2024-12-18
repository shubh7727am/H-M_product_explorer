import 'package:flutter/material.dart';



class AppThemes {
  // Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.teal, // Cool primary color
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardThemeData(color:Colors.teal.shade200 ),

      appBarTheme: AppBarTheme(
        color: Colors.teal, // Matching app bar color
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold, // Make title bold for emphasis
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black87), // Slightly lighter black
        bodyMedium: TextStyle(color: Colors.black54),
        displayLarge: TextStyle(color: Colors.teal, fontSize: 24, fontWeight: FontWeight.bold), // Headline in primary color
      ),
      colorScheme: ColorScheme(
        primary: Colors.teal,

        secondary: Colors.pinkAccent, // Trendy secondary color

        surface: Colors.white,

        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,

        onError: Colors.white, brightness: Brightness.light,
      ),
      // Add more theme customization here if needed
    );
  }

  // Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.teal,

      scaffoldBackgroundColor: Colors.grey[900]!, // Darker scaffold background
      appBarTheme: AppBarTheme(
        color: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),

      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        displayLarge: TextStyle(color: Colors.teal, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      colorScheme: ColorScheme(
        primary: Colors.teal,

        secondary: Colors.pinkAccent,

        surface: Colors.grey[850]!,

        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white,

        onError: Colors.white, brightness: Brightness.dark,
      ),
      // Add more theme customization here if needed
    );
  }
}
