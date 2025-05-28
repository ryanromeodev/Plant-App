import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:plantapp/Data/fabtestfun.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantapp/Data/plant.dart';
import 'strings.dart';

class PlantData {
  // "storage/emulated/0/FlutterPlantData/plantfile.json";

  /// The [_supplyPlist] method act as the part which reads the list in the
  /// initial instace of the program.
  /// The method returns a [Plant] object list which is in Future reference.
  Future<List<Plant>> get getplantData async => await _supplyPlist();

  Future<String> get filelocation async => await createFolder(filename);

  _supplyPlist() {
    Future<List<Plant>> plantList = readJson();
    return plantList;
  }

  ///Writing the [Plant] Data to the json file
  void writeJson(List<Plant> plants) async {
    String loc = await filelocation;
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

  ///[readJson] method reads the json Plant file and then populates the
  ///[Plant] list which is ofcourse a [Future] details
  Future<List<Plant>> readJson() async {
    List<Plant> plantList = [];

    ///Checks for permission if possible
    var status = await Permission.storage.status;
    developer.log(
      "$green[data:readJson]Phone permission status: $status$reset",
    );
    try {
      if (!status.isGranted) {
        developer.log("$yellow[data:readJson]requesting again$reset");
        openAppSettings();
      }
      String path = await filelocation;
      developer.log("$green[data:readJson]creation success$path $status$reset");
      String str = await File("$path/$filename").readAsString();
      // String str = await File("assets\\plantdetails.json").readAsString();
      List<dynamic> plantListJson = await jsonDecode(str);
      if (plantListJson.isEmpty) {
        // developer.log("$red[]data:readJson] list is null$reset");
        // TODO: [functionality] Load from a file_picker here
        plantListJson = await loadtestdata();
      }
      for (var i = 0; i < plantListJson.length; i++) {
        plantList.add(
          Plant(
            plantname: plantListJson[i]["plantname"],
            plantdetails: plantListJson[i]["plantdetails"],
            plantdate: plantListJson[i]["plantdate"],
          ),
        );
      }
      print(plantList.length);
      developer.log(
        "$green[data:readJson]complete read is success $status$reset",
      );
    } on PathNotFoundException catch (_) {
      developer.log("$red[data:readJson]exception caught while reading$reset");
    }
    developer.log(
      "$white[data:readJson]status of the permission is :$status$reset",
    );
    return plantList;
  }
}
