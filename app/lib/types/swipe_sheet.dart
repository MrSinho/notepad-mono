import 'dart:ui';

import 'package:flutter/material.dart';

import '../types/blur_filter.dart';

import '../backend/handle.dart';



class SwipeSheet extends StatefulWidget {
  SwipeSheet({
      Key? key,
      this.handle,
      this.children,
      this.minChildSize,
      this.initialChildSize,
      this.maxChildSize,
      this.triggerSwipeVelocity,
      this.maximizeThreshold,
      this.minimizeThreshold
    }
  );

  final Handle?       handle;

  final List<Widget>? children;

  final double?       minChildSize;
  final double?       initialChildSize;
  final double?       maxChildSize;
  final double?       triggerSwipeVelocity;
  final double?       maximizeThreshold;
  final double?       minimizeThreshold;


  @override
  State<SwipeSheet> createState() => SwipeSheetState();
}

class SwipeSheetInfo {
  late GlobalKey<SwipeSheetState> key;
  late SwipeSheet                  widget;

  SwipeSheetInfo({
      Handle?       handle,
      List<Widget>? children,
      double?       minChildSize,
      double?       initialChildSize,
      double?       maxChildSize,
      double?       triggerSwipeVelocity,
      double?       maximizeThreshold,
      double?       minimizeThreshold,
    }
  ) {
    
    key = GlobalKey<SwipeSheetState>();

    widget = SwipeSheet(
      key: key,
      handle: handle,
      children: children,
      minChildSize: minChildSize,
      initialChildSize: initialChildSize,
      maxChildSize: maxChildSize,
      triggerSwipeVelocity: triggerSwipeVelocity,
      maximizeThreshold: maximizeThreshold,
      minimizeThreshold: minimizeThreshold
    );

  }

}

class SwipeSheetState extends State<SwipeSheet> {
  DraggableScrollableController controller = DraggableScrollableController();
  
  late List<Widget> children;

  late double minChildSize;
  late double initialChildSize;
  late double maxChildSize; 
  late double triggerSwipeVelocity;
  late double maximizeThreshold;  
  late double minimizeThreshold;  

  late BlurFilterInfo collection_blurFilter;
  

  @override
  void initState() {

    children = widget.children ?? [];

    minChildSize         = widget.minChildSize         ?? 0.04;
    initialChildSize     = widget.initialChildSize     ?? 0.04;
    maxChildSize         = widget.maxChildSize         ?? 1.0;
    triggerSwipeVelocity = widget.triggerSwipeVelocity ?? 0.0;
    maximizeThreshold    = widget.maximizeThreshold    ?? 0.5;
    minimizeThreshold    = widget.minimizeThreshold    ?? 0.5;
    
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

    collection_blurFilter = BlurFilterInfo(handle: widget.handle);

    WidgetsBinding.instance.addPostFrameCallback(//otherwise keys are invalid
      (Duration duration) {
        collection_blurFilter.key.currentState!.graphics_setChildren([sheet]);
      }
    );

    super.initState();
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
    setState(() { children = newChildren; });
  }

  @override
  Widget build(BuildContext context) {
    
    return collection_blurFilter.widget;

  }
}