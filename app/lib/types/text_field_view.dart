import 'package:flutter/material.dart';



class TextFieldView extends StatefulWidget {
  const TextFieldView({
      super.key,
      required this.textField
    }
  );

  final TextField textField;

  @override
  State<TextFieldView> createState() => TextFieldViewState();
}

class TextFieldViewInfo {
  
  late GlobalKey<TextFieldViewState> key;
  late TextFieldView                 widget;

  TextFieldViewInfo({required TextField textField}) {
    
    key    = GlobalKey<TextFieldViewState>();
    widget = TextFieldView(key: key, textField: textField);

  }

}

class TextFieldViewState extends State<TextFieldView> {

  TextField textField = const TextField();

  @override
  void initState() {
    textField = widget.textField;
    super.initState();
  }

  void graphicsSetTextField(TextField newTextField) {
    textField = newTextField;
  }

  @override
  Widget build(BuildContext context) {
    return textField;
  }
}