
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase/supabase.dart';

import '../types/dashboard.dart';
import '../types/drawer.dart';
import '../types/login.dart';
import '../types/nav_bar.dart';
import '../types/nav_page.dart';
import '../types/profile_view.dart';
import '../types/user_header.dart';
import '../types/swipe_sheet.dart';



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

  late DashboardInfo   dashboardInfo;
  late DrawerInfo      drawerInfo;
  late LoginInfo       loginInfo;
  late NavPageInfo     navPageInfo;
  late NavBarInfo      navBarInfo;
  late ProfileViewInfo profileViewInfo;
  late UserHeaderInfo  userHeaderInfo;

  //late Map<String, DashboardInfo>   dashboardInfos;
  //late Map<String, DrawerInfo>      drawerInfos;
  //late Map<String, LoginInfo>       loginInfos;
  //late Map<String, NavPageInfo>     navPageInfos;
  //late Map<String, NavBarInfo>      navBarInfos;
  //late Map<String, ProfileViewInfo> profileViewInfos;
  //late Map<String, UserHeaderInfo>  userHeaderInfos;
  late Map<String, SwipeSheetInfo>  swipeSheetInfos;

}


class Handle {

  SupabaseObjects supabase_objects = SupabaseObjects();
  Types           types            = Types();
  Profile         profile          = Profile();

  void initAll() {
    WidgetsFlutterBinding.ensureInitialized();

    initializeSupabase(this);

    types.dashboardInfo   = DashboardInfo  (handle: this);
    types.drawerInfo      = DrawerInfo     (handle: this);
    types.loginInfo       = LoginInfo      (handle: this);
    types.navPageInfo     = NavPageInfo    (handle: this);
    types.navBarInfo      = NavBarInfo     (handle: this);
    types.profileViewInfo = ProfileViewInfo(handle: this);
    types.userHeaderInfo  = UserHeaderInfo (handle: this);

    types.swipeSheetInfos = {};
  
    WidgetsFlutterBinding.ensureInitialized();
  }

}