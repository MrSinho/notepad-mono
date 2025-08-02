import 'package:flutter/material.dart';
import 'package:template/backend/check.dart';
import 'package:template/static/utils.dart';

//import '../backend/handle.dart';



class DynamicStack extends StatefulWidget {
  DynamicStack({
      Key? key,
      //this.handle,
      this.children
    }
  );

  //final Handle?       handle;
  final List<Widget>? children;

  @override
  State<DynamicStack> createState() {
    return DynamicStackState();
  }

}



class DynamicStackInfo {
  late GlobalKey<DynamicStackState> key;
  late DynamicStack                 widget;

  DynamicStackInfo({/*Handle? handle,*/ List<Widget>? children}) {
    key    = GlobalKey<DynamicStackState>();
    widget = DynamicStack(key: key, /*handle: handle,*/ children: children);

  }

}

DynamicStackInfo assertDynamicStackInfoMemory(DynamicStackInfo? src) {

  DynamicStackInfo defaultValue = DynamicStackInfo(
    children: [
      warningText("assertMemory: invalid DynamicStackInfo memory")
    ]
  );

  return assertMemory(src, defaultValue);
}


class DynamicStackState extends State<DynamicStack> {

  late List<Widget> children = [];

  @override
  void initState() {
    children = widget.children ?? [];
    super.initState();
  }

  void setChildren(List<Widget> newChildren) {
    setState(() {
      children = newChildren;
    });
  }

  @override
  Widget build(BuildContext context) {

    Stack stack = Stack(
      children: children,
    );

    return stack;
  }

}