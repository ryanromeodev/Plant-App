import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantapp/UI/plantorganiser.dart';
import 'package:google_fonts/google_fonts.dart';

class Adenium extends StatelessWidget {
  const Adenium({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: "Adenium plant organiser",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          // ···
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.roboto(
            color: Colors.blueGrey,
            fontSize: 35,
          ),
          displayMedium: GoogleFonts.roboto(
            color: Colors.blueGrey,
            fontSize: 25,
          ),
          headlineLarge: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 30.0,
          ),
          headlineMedium: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 20.0,
            wordSpacing: 2,
          ),
          headlineSmall: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 16.0,
          ),
          bodyMedium: GoogleFonts.roboto(color: Colors.white),
          // bodySmall: GoogleFonts.roboto(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          // backgroundColor: Colors.lightBlue,
        ),
      ),
      home: const PlantOrg(),
    );
  }
}
