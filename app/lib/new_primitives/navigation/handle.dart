
import 'package:flutter/material.dart';

import '../../types/scaffold_view.dart';
import 'drawer.dart';
import 'nav_bar.dart';
import 'nav_page.dart';
import '../profile_view.dart';
import '../user_header.dart';



class PublicProfile {
  String username  = "";
  String createdAt = "";
  String bio       = "";
  String status    = "";
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

  //late DashboardInfo   dashboardInfo;
  late DrawerInfo      drawerInfo;
  late NavPageInfo     navPageInfo;
  late NavBarInfo      navBarInfo;
  //late ProfileViewInfo profileViewInfo;
  late UserHeaderInfo  userHeaderInfo;

}


class Handle {

  Types   types   = Types();
  Profile profile = Profile();

  void initTypes() {
    WidgetsFlutterBinding.ensureInitialized();

    //types.dashboardInfo   = DashboardInfo  (handle: this);
    types.drawerInfo      = DrawerInfo     (handle: this);
    types.navPageInfo     = NavPageInfo    (handle: this);
    //types.navBarInfo      = NavBarInfo     (handle: this);
    //types.profileViewInfo = ProfileViewInfo(handle: this);
    types.userHeaderInfo  = UserHeaderInfo (handle: this);

    //types.swipeSheetInfos = {};
  }

}