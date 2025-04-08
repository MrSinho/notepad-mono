import 'dart:ui';

import 'package:flutter/material.dart';

import '../backend/handle.dart';



class BlurFilter extends StatefulWidget {
  const BlurFilter({super.key, required this.handle});

  final Handle       handle;

  @override
  State<BlurFilter> createState() => state_BlueFilter();
}

class collection_BlurFilter {
  late GlobalKey<state_BlueFilter> key;
  late BlurFilter                  widget;

  collection_BlurFilter({required Handle handle}) {
    
    key    = GlobalKey<state_BlueFilter>();
    widget = BlurFilter(handle: handle, key: key);

  }

}

class state_BlueFilter extends State<BlurFilter> {

  double blurX   = 0.0;
  double blurY   = 0.0;
  double opacity = 0.0;

  List<Widget> children = [];

  void setBlurAmount(double amountX, double amountY) {
    blurX = amountX;
    blurY = amountY;
  }

  void graphics_setBlurAmount(double amountX, double amountY) {
    setState(() => setBlurAmount(amountX, amountY));
  }

  void graphics_setChildren(List<Widget> newChildren) {
    setState(() => children = newChildren);
  }

  Widget filterBuilder() {

    BackdropFilter filter = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
      child: Container(
        color: Colors.black.withOpacity(opacity),
      ),
    );

    return filter;
  }

  @override
  Widget build(BuildContext context) {
    
    List<Widget> stackContent = [
      Builder(builder: (context) { return filterBuilder(); }),
    ];

    stackContent.addAll(children);
    
    Stack stack = Stack(
      children: stackContent
    );
    
    return stack;

  }
}