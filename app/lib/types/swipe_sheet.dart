import 'dart:ui';

import 'package:flutter/material.dart';

import '../types/blur_filter.dart';

import '../backend/handle.dart';



class SwipeSheet extends StatefulWidget {
  const SwipeSheet({super.key, required this.handle, required this.children});

  final Handle       handle;
  final List<Widget> children;

  @override
  State<SwipeSheet> createState() => state_SwipeSheet();
}

class collection_SwipeSheet {
  late GlobalKey<state_SwipeSheet> key;
  late SwipeSheet                  widget;

  collection_SwipeSheet({required Handle handle, required List<Widget> children}) {
    
    key    = GlobalKey<state_SwipeSheet>();
    widget = SwipeSheet(handle: handle, key: key, children: children);

  }

}

class state_SwipeSheet extends State<SwipeSheet> {
  DraggableScrollableController controller = DraggableScrollableController();

  double minChildSize         = 0.04;
  double initialChildSize     = 0.04;
  double maxChildSize         = 1.0; 
  double triggerSwipeVelocity = 0.0;
  double maximizeThreshold    = 0.5;  
  double minimizeThreshold    = 0.5;  

  List<Widget> children = [];

  late collection_BlurFilter collection_blurFilter;
  


  @override
  void initState() {
    super.initState();

    children = widget.children;
    
    controller.addListener(graphics_updateFilter);

    DraggableScrollableSheet sheet = DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize    : minChildSize,
      maxChildSize    : maxChildSize,
      controller      : controller,
      snap            : true,
      snapSizes       : const [0.1, 0.5, 0.8],
      builder: scrollableSheetBuilder
    );

    collection_blurFilter = collection_BlurFilter(handle: widget.handle);

    WidgetsBinding.instance.addPostFrameCallback(//otherwise keys are invalid
      (Duration duration) {
        collection_blurFilter.key.currentState!.graphics_setChildren([sheet]);
      }
    );

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void graphics_maximize() {
    setState(() { controller.animateTo(maxChildSize, duration: const Duration(milliseconds: 200), curve: Curves.linear); });
  }

  void graphics_minimize() {
    setState(() { controller.animateTo(minChildSize, duration: const Duration(milliseconds: 200), curve: Curves.linear); });
  }

  void onVerticalSwipe(DragEndDetails details) {
    double velocity = details.primaryVelocity ?? 0.0;

    if (velocity < -triggerSwipeVelocity) {//up
      graphics_maximize();
    } 

    else if (velocity > triggerSwipeVelocity) {
      graphics_minimize();
    }

    if (velocity == 0 && controller.size >= maximizeThreshold) {
      graphics_maximize();
    }
    
    if (velocity == 0 && controller.size < minimizeThreshold) {
      graphics_minimize();
    }

  }

  void onVerticalUpdate(details) {
    double delta   = details.delta.dy / MediaQuery.of(context).size.height;
    double newSize = controller.size - delta;
    controller.jumpTo(
      newSize.clamp(minChildSize, maxChildSize),
    );
  }

  void graphics_updateFilter() {
    double amount = controller.size * 20.0;

    if (controller.size == minChildSize) { amount = 0.0; }

    collection_blurFilter.key.currentState!.graphics_setBlurAmount(amount, amount);
  }

  Widget scrollableSheetBuilder(BuildContext context, ScrollController scrollController) {

    Container dragHandle = Container(
      width: 50,
      height: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(bottom: 8.0),
    );

    List<Widget> embeddedWidgets = [
      dragHandle
    ];

    embeddedWidgets.addAll(children);

    CustomScrollView scrollView = CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: GestureDetector(
            onVerticalDragEnd: onVerticalSwipe,
            onVerticalDragUpdate: onVerticalUpdate,
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              child: Column(
                children: embeddedWidgets
              ),
            ),
          ),
        ),
      ],
    );

    GestureDetector gesture = GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
        ),
        child: scrollView
      ),
    );

    return gesture;

  }

  void graphics_setChildren(List<Widget> newChildren) {
    setState(() => children = newChildren);
  }

  @override
  Widget build(BuildContext context) {
    
    return collection_blurFilter.widget;

  }
}