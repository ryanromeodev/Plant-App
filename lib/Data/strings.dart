import 'dart:io';

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
