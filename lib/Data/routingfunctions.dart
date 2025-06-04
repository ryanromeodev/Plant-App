import 'package:flutter/material.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Pages/addpage.dart';
import 'package:plantapp/Pages/settingspage.dart';
import 'package:plantapp/Pages/updatepage.dart';

Future<Plant> addingPlantPage(BuildContext context) async {
  final Plant plant = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Addplant()),
  );
  // When a BuildContext is used from a StatefulWidget, the mounted property
  // must be checked after an asynchronous gap.
  if (!context.mounted) {
    return Plant(plantid: "", plantname: "", plantdetails: "", plantdate: "");
  }

  return plant;
}

Future<(dynamic, dynamic, dynamic, dynamic, dynamic)> updatePlantPage(
  BuildContext context,
  Plant plant,
) async {
  final (
    Plant outPlant,
    String id,
    String name,
    String details,
    String date,
  ) = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UpdatePlant(plant: plant)),
  );
  if (!context.mounted) {
    return (
      Plant(plantid: "", plantname: "", plantdetails: "", plantdate: ""),
      "",
      "",
      "",
      "",
    );
  }
  return (outPlant, id, name, details, date);
}

Future<dynamic> displaySettingsPage(
  BuildContext context,
  List<Plant> trashplants,
  List<Plant> plants,
) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Settings(trashlist: trashplants, plants: plants),
    ),
  );
  if (!context.mounted) {
    return;
  }
}
