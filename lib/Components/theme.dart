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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displaySmall: GoogleFonts.notoSerifMalayalam(),
          titleLarge: GoogleFonts.notoSerifMalayalam(),
          bodyLarge: GoogleFonts.notoSerifMalayalam(),
          bodyMedium: GoogleFonts.notoSerifMalayalam(),
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
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          displaySmall: GoogleFonts.notoSerifMalayalam(),
          titleLarge: GoogleFonts.notoSerifMalayalam(),
          bodyLarge: GoogleFonts.notoSerifMalayalam(),
          bodyMedium: GoogleFonts.notoSerifMalayalam(),
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
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
