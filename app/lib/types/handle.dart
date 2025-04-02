
import 'package:supabase/supabase.dart';
import "package:supabase_flutter/supabase_flutter.dart";

class SupabaseObjects {

  late Supabase       instance;
  late SupabaseClient client;
  late GoTrueClient   auth;

}


class Handle {


  String email = "";

  SupabaseObjects supabase_objects = SupabaseObjects();

}