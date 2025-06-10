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
  Color color1 = Color(0xffffa91c);
  Color color2 = Color(0xfffe9553);
  Color color3 = Color(0xffb57400);
  Color color4 = Color(0xff44525f);
  Color color5 = Color(0xffb5cbd8);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Adenium",
      debugShowCheckedModeBanner: false,
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }

  ThemeData theme(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: brightness,
        primary: color1,
        secondary: color5,
        tertiary: color4,
      ),
      textTheme: TextTheme(
        // displaySmall: GoogleFonts.notoSerifMalayalam(),
        headlineSmall: GoogleFonts.notoSerifMalayalam(
          //plant_name
        ),
        titleLarge: GoogleFonts.notoSerifMalayalam(
          //headtitle
        ),
        bodyLarge: GoogleFonts.notoSerifMalayalam(
          //whole_body
        ),
        bodyMedium: GoogleFonts.notoSerifMalayalam(
          //plant_note
        ),
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
        foregroundColor: color1,
        backgroundColor: color4,
        iconSize: 30,
      ),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
