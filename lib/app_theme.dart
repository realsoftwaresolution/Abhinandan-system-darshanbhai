// lib/app_theme.dart

import 'package:flutter/material.dart';

// Define your global theme data
final ThemeData lightTheme = ThemeData(
  primaryColor: const Color(0xFFC50404), // Primary color
  secondaryHeaderColor: const Color(0xFF00796B), // Secondary color (Teal)
  hintColor: const Color(0xFF64FFDA), // Accent color for floating buttons, etc.
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFC50404)),
    displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFC50404)),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFC50404), // Button color
    textTheme: ButtonTextTheme.primary, // Button text color
  ),
  scaffoldBackgroundColor: Colors.white, // Background color for scaffold
  appBarTheme: const AppBarTheme(
    color: Color(0xFFC50404), // AppBar color
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: const Color(0xFFC50404), // Primary color
  secondaryHeaderColor: const Color(0xFF00796B), // Secondary color (Teal)
  hintColor: const Color(0xFF64FFDA), // Accent color for floating buttons, etc.
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFC50404), // Button color
    textTheme: ButtonTextTheme.primary, // Button text color
  ),
  scaffoldBackgroundColor: const Color(0xFF121212), // Background color for scaffold
  appBarTheme: const AppBarTheme(
    color: Color(0xFFC50404), // AppBar color
  ),
);
