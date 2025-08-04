import 'package:flutter/material.dart';



class ListTileView extends StatefulWidget {
  const ListTileView({
      super.key,
      required this.listTile,
    }
  );

  final ListTile listTile;

  @override
  State<ListTileView> createState() => ListTileViewState();
}

class ListTileViewInfo {
  
  late GlobalKey<ListTileViewState> key;
  late ListTileView                 widget;

  ListTileViewInfo({required ListTile listTile}) {
    key    = GlobalKey<ListTileViewState>();
    widget = ListTileView(key: key, listTile: listTile);
  }

}

class ListTileViewState extends State<ListTileView> {

  ListTile listTile = const ListTile();

  @override
  void initState() {
    listTile = widget.listTile;
    super.initState();
  }
  
  void graphicsSetListTile(ListTile newListTile) {
    setState(() => listTile = newListTile);
  }

  @override
  Widget build(BuildContext context) {

    InkWell inkWell = InkWell(
      child: listTile
    );

    return inkWell;
  }
}