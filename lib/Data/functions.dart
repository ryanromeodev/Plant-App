import 'package:flutter/material.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/notification.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Data/strings.dart';

void snackbarfun(context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void fileTest(context) {
  PlantData pdata = PlantData();
  pdata.readJson(plantsfile);
}

///[plantSorter] sort out plants in the order of date
///it serve the saving of trash and plants - functionality
plantSorter(List<Plant> unsortedPlantList, List<Plant> trashlist) {
  unsortedPlantList.sort(
    (a, b) =>
        (DateTime.parse(b.plantdate)).compareTo(DateTime.parse(a.plantdate)),
  );
  trashlist.sort(
    (a, b) =>
        (DateTime.parse(a.plantdate)).compareTo(DateTime.parse(b.plantdate)),
  );
  PlantData().writeJson(unsortedPlantList, plantsfile);
  PlantData().writeJson(trashlist, trashfile);
}

setNotification(Plant plant) {
  if (plant.plantnote.isNotEmpty && plant.plantnote.length > 9) {
    int pending = pendingdays(plant.plantnote);
    print(pending);
    scheduledNotification(
      plant.plantname,
      plant.plantdetails,
      int.parse(plant.plantid),
      0,
      0,
      15,
    );
  }
}

removeNotification(Plant plant) {
  deleteNotificationChannel(plant.plantid);
}

/// [dateTimeFormatter] is used to deal with the format of the DateTime and String
String dateTimeFormatter(DateTime? datetime) {
  //the function returns a string Date
  final datetimeparsed = DateTime.parse(datetime.toString());
  return "${datetimeparsed.day}-${datetimeparsed.month}-${datetimeparsed.year}";
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

int pendingdays(String plantdate) {
  final String year = plantdate.substring(0, 4);
  final String month = plantdate.substring(5, 7);
  final String day = plantdate.substring(8, 10);
  final from = DateTime(int.parse(year), int.parse(month), int.parse(day));
  final to = DateTime.now();
  final int pendingDays = ((to.difference(from).inHours / 24) * -1).ceil();
  return pendingDays;
}

List<String> getplantnames(List<Plant> plist) {
  List<String> outlist = [];
  for (Plant p in plist) {
    outlist.add(p.plantname);
  }
  return outlist.toSet().toList();
}
