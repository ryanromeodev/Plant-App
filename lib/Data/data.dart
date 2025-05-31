import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
      developer.log("$green[data:writeJson] writing is success$reset");
    } catch (_) {
      developer.log("$red[data:writeJson] Exception found$reset");
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
      developer.log(
        "$green[data:readJson] creation success$path $status$reset",
      );
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
      developer.log(
        "$green[data:readJson] complete read of ${plantList.length} plants is success $status$reset",
      );
    } on PathNotFoundException catch (_) {
      developer.log("$red[data:readJson] exception caught while reading$reset");
    }
    developer.log(
      "$white[data:readJson] status of the permission is :$status$reset",
    );
    return plantList;
  }
}

Future<String> createFolder(String filename) async {
  final dir = Directory(
    '${Platform.isAndroid ?
        // (await getExternalStorageDirectory())!.path //FOR ANDROID
        (await getExternalStorageDirectory())!.path : (await getApplicationSupportDirectory()).path //FOR IOS
        }/$filename',
  );
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if (await dir.exists()) {
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

saveToDownloads(List<Plant> plants, String filename) async {
  String loc = generalDownloadDir.path;
  developer.log(
    "$green[data:saveToDownloads] before filewriting part$loc$reset",
  );
  try {
    File f = await File("$loc/$filename").create(recursive: true);
    final p = plants.map((plant) => plant.toJson()).toList();
    f.writeAsString(jsonEncode(p));
    developer.log("$green[data:saveToDownloads] writing is success$reset");
  } catch (_) {
    developer.log("$red[data:saveToDownloads] Exception found$reset");
  }
  developer.log("$green[data:saveToDownloads] directory path is :$loc$reset");
}
