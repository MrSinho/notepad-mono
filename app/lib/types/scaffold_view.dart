import 'package:flutter/material.dart';

import 'app_bar_view.dart';
import 'bottom_navigation_bar_view.dart';
import 'bottom_sheet_view.dart';
import 'drawer_view.dart';

import '../backend/supabase/listen.dart';



class ScaffoldView extends StatefulWidget {
  const ScaffoldView({
    super.key,
    this.appBarViewInfo,
    this.bottomNavigationBarViewInfo,
    this.body,
    this.drawerViewInfo,
    this.bottomSheetViewInfo,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator
  });

  final AppBarViewInfo? appBarViewInfo;
  final BottomNavigationBarViewInfo? bottomNavigationBarViewInfo;
  final Widget? body;
  final DrawerViewInfo? drawerViewInfo;
  final BottomSheetViewInfo? bottomSheetViewInfo;

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;


  @override
  State<ScaffoldView> createState() {
    return ScaffoldViewState();
  }

}

class ScaffoldViewInfo {

  late GlobalKey<ScaffoldViewState> key;
  late ScaffoldView                 widget;

  ScaffoldViewInfo({
    AppBarViewInfo? appBarViewInfo,
    BottomNavigationBarViewInfo? bottomNavigationBarViewInfo,
    Widget? body,
    DrawerViewInfo? drawerViewInfo,
    BottomSheetViewInfo? bottomSheetViewInfo,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator
  }) {
    key    = GlobalKey<ScaffoldViewState>();
    widget = ScaffoldView(
      key: key,
      appBarViewInfo: appBarViewInfo,
      bottomNavigationBarViewInfo: bottomNavigationBarViewInfo,
      body: body,
      drawerViewInfo: drawerViewInfo,
      bottomSheetViewInfo: bottomSheetViewInfo,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
    );
  }

}

class ScaffoldViewState extends State<ScaffoldView> {

  AppBarViewInfo? appBarViewInfo;
  BottomNavigationBarViewInfo? bottomNavigationBarViewInfo;
  Widget? body;
  DrawerViewInfo? drawerViewInfo;
  BottomSheetViewInfo? bottomSheetViewInfo;

  Widget? floatingActionButton;
  FloatingActionButtonLocation? floatingActionButtonLocation;
  FloatingActionButtonAnimator? floatingActionButtonAnimator;

  @override
  void initState() {
    appBarViewInfo = widget.appBarViewInfo;
    bottomNavigationBarViewInfo = widget.bottomNavigationBarViewInfo;
    body = widget.body;
    drawerViewInfo = widget.drawerViewInfo;
    bottomSheetViewInfo = widget.bottomSheetViewInfo;
    floatingActionButton = widget.floatingActionButton;
    floatingActionButtonLocation = widget.floatingActionButtonLocation;
    floatingActionButtonAnimator = widget.floatingActionButtonAnimator;
    super.initState();
    listenToNotes(context);
  }

  void graphicsSetAppBarViewInfo(AppBarViewInfo newAppBarViewInfo) {
    setState(() {
      appBarViewInfo = newAppBarViewInfo;
    });
  }

  void graphicsSetBottomNavigationBarViewInfo(BottomNavigationBarViewInfo newbottomNavigationBarViewInfo) {
    setState(() {
      bottomNavigationBarViewInfo = newbottomNavigationBarViewInfo;
    });
  }

  void graphicsSetBody(Widget newBody) {
    setState(() {
      body = newBody;
    });
  }

  void graphicsSetDrawerViewInfo(DrawerViewInfo newDrawerViewInfo) {
    setState(() {
      drawerViewInfo = newDrawerViewInfo;
    });
  }

  void graphicsSetBottomSheetViewInfo(BottomSheetViewInfo newBottomSheetViewInfo) {
    setState(() {
      bottomSheetViewInfo = newBottomSheetViewInfo;
    });
  }

  @override
  Widget build(BuildContext context) {

    Scaffold scaffold = Scaffold(
      appBar:              appBarViewInfo?.widget.appBar, 
      bottomNavigationBar: bottomNavigationBarViewInfo?.widget.bottomNavigationBar, 
      drawer:              drawerViewInfo?.widget.drawer, 
      body:                body,//If you want to change the state of the body you better save the Stateful widget data in AppData
      bottomSheet:         bottomSheetViewInfo?.widget.bottomSheet, 
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator
    );

    return scaffold;
  }

}

