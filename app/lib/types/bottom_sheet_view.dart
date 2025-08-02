import 'package:flutter/material.dart';



class BottomSheetView extends StatefulWidget {
  const BottomSheetView({
      super.key,
      required this.bottomSheet
    }
  );

  final BottomSheet bottomSheet;

  @override
  State<BottomSheetView> createState() => BottomSheetViewState();
}

class BottomSheetViewInfo {
  
  late GlobalKey<BottomSheetViewState> key;
  late BottomSheetView                 widget;

  BottomSheetViewInfo({required BottomSheet bottomSheet}) {
    
    key    = GlobalKey<BottomSheetViewState>();
    widget = BottomSheetView(key: key, bottomSheet: bottomSheet);

  }

}



class BottomSheetViewState extends State<BottomSheetView> {

  BottomSheet bottomSheet = BottomSheet(onClosing: (){}, builder: (context) { return const Text(""); },);

  @override
  void initState() {
    bottomSheet = widget.bottomSheet;
    super.initState();
  }

  void graphicsSetBottomSheet(BottomSheet newBottomSheet) {
    bottomSheet = newBottomSheet;
  }

  @override
  Widget build(BuildContext context) {
        
    return bottomSheet;

  }
}