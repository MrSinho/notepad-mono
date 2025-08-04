import 'dart:ui';

import 'package:flutter/material.dart';



class BlurFilter extends StatefulWidget {
  const BlurFilter({
      super.key,
      this.blurX,
      this.blurY,
      this.opacity
    }
  );

  final double? blurX;
  final double? blurY;
  final double? opacity;

  @override
  State<BlurFilter> createState() => BlurFilterState();
}

class BlurFilterInfo {
  
  late GlobalKey<BlurFilterState> key;
  late BlurFilter                  widget;

  BlurFilterInfo({/*Handle? handle,*/ double? blurX, double? blurY, double? opacity}) {
    
    key    = GlobalKey<BlurFilterState>();
    widget = BlurFilter(key: key, /*handle: handle,*/ blurX: blurX, blurY: blurY, opacity: opacity);

  }

}

class BlurFilterState extends State<BlurFilter> {

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

  void graphicsSetBlurAmount(double amountX, double amountY) {
    setState(() => setBlurAmount(amountX, amountY));
  }

  void graphicsSetChildren(List<Widget> newChildren) {
    setState(() => children = newChildren);
  }

  Widget filterBuilder() {

    BackdropFilter filter = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
      child: Container(
        color: Colors.black54,//missing opacity regulation here
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