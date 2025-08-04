import 'package:flutter/material.dart';



class WidgetView extends StatefulWidget {
  const WidgetView({
      super.key,
      required this.widgetData
    }
  );
  
  final Widget widgetData;

  @override
  State<WidgetView> createState() => WidgetViewState();
}

class WidgetViewInfo {
  
  late GlobalKey<WidgetViewState> key;
  late WidgetView                 widget;

  WidgetViewInfo({required Widget widgetData}) {
    key    = GlobalKey<WidgetViewState>();
    widget = WidgetView(key: key, widgetData: widgetData);
  }

}


class WidgetViewState extends State<WidgetView> {

  Widget widgetData = const Text("");

  @override
  void initState() {
    widgetData = widget.widgetData;
    super.initState();
  }

  void graphicsSetWidgetData(Widget newWidgetData) {
    widgetData = newWidgetData;
  }

  @override
  Widget build(BuildContext context) {
    return widgetData;
  }
}