import 'package:flutter/material.dart';



Widget assertWidget(Widget? widget) {
  return widget ?? const Text("NULL");
}

Type assertMemory<Type>(Type? memory, Type defaultMemory) {
  if (memory == null) { debugPrint("assertMemory: type $Type was $memory"); }
  return memory ?? defaultMemory;
}