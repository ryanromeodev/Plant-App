import 'package:flutter/material.dart';
import 'package:plantapp/Pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class Adenium extends StatefulWidget {
  const Adenium({super.key});

  @override
  State<Adenium> createState() => _AdeniumState();

  /// ↓↓ ADDED
  /// InheritedWidget style accessor to our State object.
  static _AdeniumState of(BuildContext context) =>
      context.findAncestorStateOfType<_AdeniumState>()!;
}

class _AdeniumState extends State<Adenium> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Adenium",
      debugShowCheckedModeBanner: false,
      theme: baseTheme(Brightness.light),
      darkTheme: baseTheme(Brightness.dark),
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }

  ThemeData baseTheme(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
        brightness: brightness,
      ),
      textTheme: TextTheme(
        // headlineLarge: GoogleFonts.aboreto(
        //   fontWeight: FontWeight.bold,
        //   textStyle: TextStyle(
        //     decoration: TextDecoration.underline,
        //     decorationStyle: TextDecorationStyle.dotted,
        //   ),
        // ),
        // headlineSmall: GoogleFonts.aboreto(),
        // titleLarge: GoogleFonts.aboreto(),
        // bodyMedium: GoogleFonts.aboreto(),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
