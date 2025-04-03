import 'package:flutter/material.dart';

import 'types/app.dart';

import 'backend/handle.dart';



Future<int> main() async {

  Handle handle = Handle();

  handle.initAll();

  App app = App(handle: handle);

  runApp(app);

  return 0;
}
