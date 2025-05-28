import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantapp/UI/plantorganiser.dart';

class Adenium extends StatelessWidget {
  const Adenium({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return const MaterialApp(
      title: "Adenium plant organiser",
      debugShowCheckedModeBanner: false,
      home: PlantOrg(),
    );
  }
}
