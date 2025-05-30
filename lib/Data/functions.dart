import 'package:flutter/material.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/UI/Pages/addpage.dart';

void snackbarfun(context) {
  final snackBar = SnackBar(
    content: const Text('I could read file here'),
    backgroundColor: Colors.black12,
    action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void fileTest(context) {
  PlantData pdata = PlantData();
  pdata.readJson();
}

Future<Plant> addingPlantPage(BuildContext context) async {
  // Plant plant = Plant(plantname: "", plantdetails: "", plantdate: "");
  final Plant plant = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Addplant()),
  );
  // When a BuildContext is used from a StatefulWidget, the mounted property
  // must be checked after an asynchronous gap.
  if (!context.mounted) {
    return Plant(plantname: "", plantdetails: "", plantdate: "");
  }

  return plant;
}

///[plantSorter] sort out plants in the order of date t serve the planting functionality
plantSorter(List<Plant> unsortedPlantList) {
  unsortedPlantList.sort(
    (a, b) =>
        (DateTime.parse(a.plantdate)).compareTo(DateTime.parse(b.plantdate)),
  );
  PlantData().writeJson(unsortedPlantList);
}

/// [dateTimeFormatter] is used to deal with the format of the DateTime and String
String dateTimeFormatter(DateTime? datetime) {
  //the function returns a string Date
  final datetimeparsed = DateTime.parse(datetime.toString());
  return "${datetimeparsed.day}-${datetimeparsed.month}-${datetimeparsed.year}";
}

List<Color> get getColorsList => [
  Colors.blueGrey,
  Colors.grey,
  // ]..shuffle();
];
List<Alignment> get getAlignments => [
  Alignment.bottomLeft,
  Alignment.bottomRight,
  Alignment.topRight,
  Alignment.topLeft,
];

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
