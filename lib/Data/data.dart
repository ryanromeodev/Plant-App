import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:file_picker/file_picker.dart';
import 'strings.dart';

class PlantData {
  // "storage/emulated/0/FlutterPlantData/plantfile.json";

  /// The [_supplyPlist] method act as the part which reads the list in the
  /// initial instace of the program.
  /// The method returns a [Plant] object list which is in Future reference.
  Future<List<Plant>> get getplantData async => await _supplyPlist();
  // Future<List<Plant>> get gettrashData async => await _supplyTlist();

  Future<String> get filelocation async => await createFolder();

  _supplyPlist() {
    Future<List<Plant>> plantList = readJson(plantsfile);
    return plantList;
  }

  // _supplyTlist() {
  //   Future<List<Plant>> plantList = readJson(trashfile);
  //   return plantList;
  // }

  ///Writing the [Plant] Data to the json file
  void writeJson(List<Plant> plants, String filename) async {
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
  Future<List<Plant>> readJson(String filename) async {
    List<Plant> plantList = [];

    ///Checks for permission if possible
    var status = await Permission.storage.status;
    developer.log(
      "$green[data:readJson] Phone permission status: $status$reset",
    );
    try {
      if (!status.isGranted) {
        developer.log("$yellow[data:readJson] requesting again$reset");
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
        // plantListJson = await loadtestdata();
      }
      for (var i = 0; i < plantListJson.length; i++) {
        plantList.add(
          Plant(
            plantid: plantListJson[i]["plantid"],
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

  void deleteJson(String filename) async {
    String path = await filelocation;
    final file = File("$path/$filename");
    if (await file.exists()) {
      try {
        await file.delete();
        developer.log(
          "$green[data:deleteJson] File deleted successfully $reset",
        );
      } catch (e) {
        developer.log("$green[data:deleteJson] Error deleting file: $e $reset");
      }
    } else {
      developer.log("$green[data:deleteJson] File does not exist. $reset");
    }
  }
}

Future<String> createFolder() async {
  final dir = Directory(
    Platform.isAndroid
        ?
        // (await getExternalStorageDirectory())!.path //FOR ANDROID
        (await getExternalStorageDirectory())!.path
        : (await getApplicationSupportDirectory()).path,
  );
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if (await dir.exists()) {
    developer.log(
      "$blue[data:createFolder] Already Exists $dir ${await dir.exists()}$reset",
    );
    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        developer.log(
          "$white[data:createFolder] File : ${entity.path} ${await dir.exists()}$reset",
        );
      } else if (entity is Directory) {
        developer.log(
          "$white[data:createFolder] Directory : ${entity.path} ${await dir.exists()}$reset",
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

Future<List<Plant>> loadtestdata() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );
  String filePath = "";
  List<Plant> plantlist = [];
  if (result != null) {
    filePath = result.files.single.path!;
    print("Selected file path: $filePath");
  } else {
    print("File picking canceled.");
  }
  try {
    String str = await File(filePath).readAsString();
    // String str = await File("assets\\plantdetails.json").readAsString();
    List<dynamic> plantListJson = await jsonDecode(str)["plants"];
    for (var i = 0; i < plantListJson.length; i++) {
      plantlist.add(
        Plant(
          plantid: plantListJson[i]["plantid"],
          plantname: plantListJson[i]["plantname"],
          plantdetails: plantListJson[i]["plantdetails"],
          plantdate: plantListJson[i]["plantdate"],
        ),
      );
    }
  } on Exception catch (e) {
    print(e);
  }

  developer.log("$yellow[data:loadtestdata] Test Data : $plantlist $reset");
  return plantlist;
}

Future<bool> saveToDownloads(
  BuildContext context,
  List<Plant> plants,
  String filename,
) async {
  String loc = generalDownloadDir.path;
  try {
    developer.log(
      "$green[data:saveToDownloads] before filewriting part$loc$reset",
    );
    File f = await File("$loc/$filename").create(recursive: true);
    final p = plants.map((plant) => plant.toJson()).toList();
    f.writeAsString(jsonEncode(p));
    developer.log("$green[data:saveToDownloads] writing is success$reset");
    return true;
  } catch (e) {
    developer.log("$red[data:saveToDownloads] Exception found$e$reset");
  }
  developer.log("$green[data:saveToDownloads] directory path is :$loc$reset");
  return false;
}
