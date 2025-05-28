import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Data/strings.dart';

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

Future<String> createFolder(String filename) async {
  final dir = Directory(
    '${Platform.isAndroid ?
        // (await getExternalStorageDirectory())!.path //FOR ANDROID
        (await getApplicationSupportDirectory()).path : (await getApplicationSupportDirectory()).path //FOR IOS
        }/$filename',
  );
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await dir.exists())) {
    developer.log(
      "$blue[fabtestfun:createFolder] Already Exists $dir ${await dir.exists()}$reset",
    );
    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        developer.log(
          "$white[fabtestfun:createFolder] File : ${entity.path} ${await dir.exists()}$reset",
        );
      } else if (entity is Directory) {
        developer.log(
          "$white[fabtestfun:createFolder] Directory : ${entity.path} ${await dir.exists()}$reset",
        );
      }
    }
    return dir.path;
  } else {
    dir.create(recursive: true);
    developer.log(
      "$yellow[fabtestfun:createFolder]creation $dir ${await dir.exists()}$reset",
    );
    return dir.path;
  }
}

Future<dynamic> loadtestdata() async {
  final String response = await rootBundle.loadString(
    'assets/plantdetails.json',
  );
  final data = await json.decode(response);
  developer.log("$yellow[fabtestfun:loadtestdata] Test Data : $data $reset");
  return data["plants"];
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

saveToDownloads(List<Plant> plants, String filename) async {
  String loc = generalDownloadDir.path;
  developer.log("$green[data:wrietJson] before filewriting part$loc$reset");
  try {
    File f = await File("$loc/$filename").create(recursive: true);
    final p = plants.map((plant) => plant.toJson()).toList();
    f.writeAsString(jsonEncode(p));
    developer.log("$green[data:writeJson]writing is success$reset");
  } catch (_) {
    developer.log("${red}Exception found$reset");
  }
  developer.log("$green[data:wrietJson] directory path is :$loc$reset");
}
