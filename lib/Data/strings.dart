import 'dart:io';

import 'package:flutter/material.dart';

const String green = "\x1B[32m";
const String reset = "\x1B[0m";
const String yellow = "\x1B[33m";
const String red = "\x1B[31m";
const String blue = "\x1b[34m";
const String magenta = "\x1b[35m";
const String cyan = "\x1b[36m";
const String white = "\x1b[37m";
const String plantsfile = "FlutterPlantData/plantfile.json";
const String trashfile = "FlutterPlantData/trashfile.json";
const String plantdownloadfile = "downloadedPlantList.json";

Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

List<AssetImage> aim = [
  AssetImage("assets/pav1.png"),
  AssetImage("assets/pav2.png"),
  AssetImage("assets/pav3.png"),
  AssetImage("assets/pav4.png"),
  AssetImage("assets/pav5.png"),
  AssetImage("assets/pav6.png"),
  AssetImage("assets/pav7.png"),
  AssetImage("assets/pav8.png"),
  AssetImage("assets/pav9.png"),
  AssetImage("assets/pav10.png"),
];
