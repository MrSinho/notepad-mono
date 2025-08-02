import 'package:flutter/material.dart';



class TextView extends StatefulWidget {
  const TextView({
      super.key,
      required this.text
    }
  );

  final Text text;

  @override
  State<TextView> createState() => TextViewState();
}

class TextViewInfo {
  
  late GlobalKey<TextViewState> key;
  late TextView                  widget;

  TextViewInfo({required Text text}) {
    
    key    = GlobalKey<TextViewState>();
    widget = TextView(key: key, text: text);

  }

}



class TextViewState extends State<TextView> {

  Text text = const Text("");

  @override
  void initState() {
    text = widget.text;
    super.initState();
  }

  void graphicsSetText(Text newText) {
    text = newText;
  }

  @override
  Widget build(BuildContext context) {
        
    return text;

  }
}