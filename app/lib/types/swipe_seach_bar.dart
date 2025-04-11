import 'package:flutter/material.dart';

import "../backend/handle.dart";



class SwipeSearchBar extends StatefulWidget {
  
  SwipeSearchBar({
      Key? key,
      this.handle,
      this.srcData,
      this.titleProperty,
      this.subtitleProperty,
      this.leftChildren,
      this.rightChildren,
    }
  );
  
  final Handle? handle;

  final List<Map<String, dynamic>>? srcData;

  final String? titleProperty;
  final String? subtitleProperty;

  final List<Widget>? leftChildren;
  final List<Widget>? rightChildren;


  @override
  SwipeSearchBarState createState() {
    return SwipeSearchBarState(); 
  }
}

class SwipeSearchBarInfo {
  late GlobalKey<SwipeSearchBarState> key;
  late SwipeSearchBar                  widget;

  SwipeSearchBarInfo({Handle? handle, List<Map<String, dynamic>>? srcData, String? titleProperty, String? subtitleProperty, List<Widget>? leftChildren, List<Widget>? rightChildren, }) {
    
    key    = GlobalKey<SwipeSearchBarState>();
    widget = SwipeSearchBar(key: key, handle: handle, srcData: srcData, titleProperty: titleProperty, subtitleProperty: subtitleProperty, leftChildren: leftChildren, rightChildren: rightChildren);

  }

}

class SwipeSearchBarState extends State<SwipeSearchBar> {

  late List<Map<String, dynamic>> srcData;
    
  late String titleProperty;
  late String subtitleProperty;

  late List<Widget> leftChildren;
  late List<Widget> rightChildren;

  List<Map<String, dynamic>> filteredResults = [];
  List<Widget>               resultTiles     = [];

  @override
  void initState() {
    srcData = widget.srcData ?? [];
    
    titleProperty    = widget.titleProperty    ?? "";
    subtitleProperty = widget.subtitleProperty ?? "";
    
    leftChildren  = widget.leftChildren  ?? [];
    rightChildren = widget.rightChildren ?? [];

    super.initState();
  }

  void setSrcData(List<Map<String, dynamic>> src, String titlePropertyName, String subtitlePropertyName) {
    srcData          = src;
    titleProperty    = titlePropertyName;
    subtitleProperty = subtitlePropertyName;

    buildTiles();
  }

  void setChildren(List<Widget> leftChildrenWidgets, List<Widget> rightChildrenWidgets) {
    leftChildren  = leftChildrenWidgets;
    rightChildren = rightChildrenWidgets;
    setState((){});
  }

  void buildTiles() {
    resultTiles = filteredResults.map((item) => resultTile(item[titleProperty], item[subtitleProperty])).toList();
    setState((){});
  }

  InkWell resultTile(String title, String subtitle) {

    ListTile tile = ListTile(
      title: Text(
        title,
        //style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(subtitle),
      //leading: const Icon(Icons.desktop_windows_rounded),
    );

    InkWell inkWell = InkWell(
      child: tile,
      onTap: () {}
    );

    return inkWell;
  }

  void filterResultsFromQuery(String query) {

    filteredResults = [];

    if (query.isNotEmpty) {
      for (Map<String, dynamic> item in srcData) {
        
        if (item.toString().toLowerCase().contains(query.toLowerCase())) {
          
          if (!filteredResults.contains(item)) {
            filteredResults.add(item);
          }
        
        }
      }
    }
    
    buildTiles();
  }

  @override
  Widget build(BuildContext context) {

    Widget searchBar = Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: SearchBar(
          hintText: "Search...",
          leading: const Icon(Icons.search),
          //backgroundColor:
          //    WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          //  if (states.contains(WidgetState.focused)) {
          //    return const Color.fromRGBO(15, 15, 15, 1.0);
          //  } else {
          //    return const Color.fromRGBO(5, 5, 5, 1.0);
          //  }
          //}),
          onChanged: filterResultsFromQuery, // Handle the search query
        ),
      ),
    );

    List<Widget> searchBarContents = [
      searchBar
    ];

    searchBarContents.insertAll(0, leftChildren);
    searchBarContents.addAll(rightChildren);

    List<Widget> columnContent = [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: searchBarContents
          ),
        ),
    ];

    if (resultTiles.isNotEmpty) {
      
      Flexible resultsUI = Flexible(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: resultTiles,
            )
          )
        )
      );

      columnContent.add(resultsUI);
    }

    Column column = Column(
      mainAxisSize: MainAxisSize.min,
      children: columnContent
    );
    
    return column;

  }


}
