import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_data.dart';



void appLog(String log) {

  String appName    = AppData.instance.packageInfo.appName;
  String appVersion = AppData.instance.packageInfo.version;

  debugPrint("[$appName][$appVersion] $log");
}

Future<String> readFile(String path) async {
  
  String text = "";

  try {

    final File file = File(path);
    text = await file.readAsString();

  } catch (error) {

    appLog("Couldn't read file: $error");

  }
  return text;
}

String formatDateTime(String src) {

  DateTime localTime = DateTime.parse(src).toLocal();

  String formatted = DateFormat('dd/MM/yyyy HH:mm').format(localTime);

  return formatted;
}

void sortMapList(List<Map<String, dynamic>> list, String key) {

  list.sort((a, b) {
    final aTime = DateTime.tryParse(a[key] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bTime = DateTime.tryParse(b[key] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bTime.compareTo(aTime);
  });

}






