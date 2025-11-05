import 'package:flutter/material.dart';

import 'backend/app_data.dart';

import 'themes.dart';



class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    MaterialApp app = MaterialApp.router(
      title: "Notepad Mono",
      debugShowCheckedModeBanner: false,
      
      routerConfig: AppData.instance.router,

      theme: darkTheme(),

      darkTheme: darkTheme(),

      highContrastTheme: brightThemeHighContrast(),

      highContrastDarkTheme: darkThemeHighContrast()
    );

    return app; 
  }

}