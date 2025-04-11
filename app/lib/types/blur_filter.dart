import 'dart:ui';

import 'package:flutter/material.dart';

import '../backend/handle.dart';



class BlurFilter extends StatefulWidget {
  const BlurFilter({
      super.key,
      this.handle,
      this.blurX,
      this.blurY,
      this.opacity
    }
  );

  final Handle? handle;

  final double? blurX;
  final double? blurY;
  final double? opacity;

  @override
  State<BlurFilter> createState() => BlueFilterState();
}

class BlurFilterInfo {
  
  late GlobalKey<BlueFilterState> key;
  late BlurFilter                  widget;

  BlurFilterInfo({Handle? handle, double? blurX, double? blurY, double? opacity}) {
    
    key    = GlobalKey<BlueFilterState>();
    widget = BlurFilter(key: key, handle: handle, blurX: blurX, blurY: blurY, opacity: opacity);

  }

}

class BlueFilterState extends State<BlurFilter> {

  late double blurX;
  late double blurY;
  late double opacity;

  List<Widget> children = [];

  @override
  void initState() {
    blurX   = widget.blurX ?? 0.0;
    blurY   = widget.blurY ?? 0.0;
    opacity = widget.opacity ?? 0.0;
    super.initState();
  }

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