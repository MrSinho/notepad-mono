import 'package:flutter/material.dart';
import 'package:template/backend/check.dart';

import 'dart:developer' as developer;



class ListTilesView extends StatefulWidget {
  const ListTilesView({
      super.key,
      required this.children
    }
  );

  final List<Widget> children;

  @override
  State<ListTilesView> createState() => ListTilesViewState();
}

class ListTilesViewInfo {
  
  late GlobalKey<ListTilesViewState> key;
  late ListTilesView                 widget;

  ListTilesViewInfo({required List<Widget> children}) {
    
    key    = GlobalKey<ListTilesViewState>();
    widget = ListTilesView(key: key, children: children,);

  }

}

ListTilesViewInfo assertTilesListMemory(ListTilesViewInfo? src) {

  ListTilesViewInfo defaultValue = ListTilesViewInfo(children: []);

  return assertMemory(src, defaultValue);

}

class ListTilesViewState extends State<ListTilesView> {

  List<Widget> children = [];

  @override
  void initState() {
    children = widget.children;
    super.initState();
  }
  
  void graphicsSetChildren(List<Widget> newChildren) {
    setState(() { 
      children = newChildren;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    Column view = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children
              )
            ),
          )
        )
      ],
    );
    
    return view;

  }
}