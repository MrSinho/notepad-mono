
import 'package:flutter/material.dart';
import "package:supabase_flutter/supabase_flutter.dart";

import 'supabase/supabase.dart';
import 'supabase/listen.dart';

import '../types/dashboard.dart';
import '../types/drawer.dart';
import '../types/login.dart';
import '../types/nav_bar.dart';
import '../types/nav_page.dart';
import '../types/profile_view.dart';
import '../types/user_header.dart';

class SupabaseObjects {

  late Supabase       instance;
  late SupabaseClient client;
  late GoTrueClient   auth;

}

class PublicProfile {
  String username   = "";
  String created_at = "";
  String bio        = "";
  String status     = "";
}

class PrivateProfile {
  String email = ""; 
  String id    = "";
  String plan  = "";
}

class Profile {

  PublicProfile  public  = PublicProfile();
  PrivateProfile private = PrivateProfile();

}

class Types {

  late collection_Dashboard   collection_dashboard;
  late collection_Drawer      collection_drawer;
  late collection_Login       collection_login;
  late collection_NavPage     collection_nav_page;
  late collection_NavBar      collection_nav_bar;
  late collection_ProfileView collection_profile_view;
  late collection_UserHeader  collection_user_header;

}


class Handle {

  SupabaseObjects supabase_objects = SupabaseObjects();
  Types           types            = Types();
  Profile         profile          = Profile();

  void initAll() {
    WidgetsFlutterBinding.ensureInitialized();

    initializeSupabase(this);

    types.collection_dashboard    = collection_Dashboard  (handle: this);
    types.collection_drawer       = collection_Drawer     (handle: this);
    types.collection_login        = collection_Login      (handle: this);
    types.collection_nav_page     = collection_NavPage    (handle: this);
    types.collection_nav_bar      = collection_NavBar     (handle: this);
    types.collection_profile_view = collection_ProfileView(handle: this);
    types.collection_user_header  = collection_UserHeader (handle: this);
  
  }

}