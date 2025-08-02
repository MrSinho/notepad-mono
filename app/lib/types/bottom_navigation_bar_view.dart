import 'package:flutter/material.dart';



class BottomNavigationBarView extends StatefulWidget {
  const BottomNavigationBarView({
      super.key,
      required this.bottomNavigationBar
    }
  );

  final BottomNavigationBar bottomNavigationBar;

  @override
  State<BottomNavigationBarView> createState() => BottomNavigationBarViewState();
}

class BottomNavigationBarViewInfo {
  
  late GlobalKey<BottomNavigationBarViewState> key;
  late BottomNavigationBarView                 widget;

  BottomNavigationBarViewInfo({required BottomNavigationBar bottomNavigationBar}) {
    
    key    = GlobalKey<BottomNavigationBarViewState>();
    widget = BottomNavigationBarView(key: key, bottomNavigationBar: bottomNavigationBar);

  }

}



class BottomNavigationBarViewState extends State<BottomNavigationBarView> {

  BottomNavigationBar bottomNavigationBar = BottomNavigationBar(items: const []);

  @override
  void initState() {
    bottomNavigationBar = widget.bottomNavigationBar;
    super.initState();
  }

  void graphicsSetBottomNavigationBar(BottomNavigationBar newBottomNavigationBar) {
    bottomNavigationBar = newBottomNavigationBar;
  }

  @override
  Widget build(BuildContext context) {
        
    return bottomNavigationBar;

  }
}