import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../new_primitives/list_tiles_view.dart';

import '../../types/list_tile_view.dart';
import '../../static/note_bottom_sheet.dart';

import '../app_data.dart';



int listenToProfile() {

  try {

    //something

    return 1;

  }
  catch (exception) {
    debugPrint('Failed listening to new profile: $exception');
    return 0;
  }

}


