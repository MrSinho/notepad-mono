import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notepad_mono/themes.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/utils/color_utils.dart';
import '../backend/utils/ui_utils.dart';

import '../backend/app_data.dart';



Widget swipeCardsBuilder(BuildContext context) {

  double titleFontSize = 15;
  double bodyFontSize  = 11.3;

  int colorPaletteColorCount = 3;

  CardSwiperController controller = CardSwiperController();

  Widget versionCard = swipeCard(
    textButtonGradient(
      Text("Release notes", style: GoogleFonts.robotoMono(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.white),),
      generateRandomColorPalette(colorPaletteColorCount), 
      () => launchUrl(Uri.parse("https://github.com/MrSinho/notepad-mono/releases/latest"))
    ),
    Text(
      "Check the latest release notes (${AppData.instance.queriesData.latestVersion["version"]})",
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: bodyFontSize, color: Colors.white),
    ),
    controller
  );

  if (AppData.instance.queriesData.currentVersion != AppData.instance.queriesData.latestVersion) {
    versionCard = swipeCard(
      textButtonGradient(
        Text("Update app", style: GoogleFonts.robotoMono(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.white),),
        generateRandomColorPalette(colorPaletteColorCount), 
        () => launchUrl(Uri.parse("https://github.com/MrSinho/notepad-mono/releases/latest"))
      ),
      Text(
        "The current app version is ${AppData.instance.queriesData.currentVersion["version"]}. Click to download the latest release (${AppData.instance.queriesData.latestVersion["version"]}).",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: bodyFontSize, color: Colors.white),
      ),
      controller
    );
  }

  List<Widget> cards = [
    versionCard,
    swipeCard(
      textButtonGradient(
        Text("Pull requests", style: GoogleFonts.robotoMono(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.white),),
        generateRandomColorPalette(colorPaletteColorCount), 
        () => launchUrl(Uri.parse("https://www.github.com/mrsinho/notepad-mono"))
      ),
      Column(
        children: [
          Text(
            "This is an open source project, pull requests are welcome for further improvements and updates.",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: bodyFontSize, color: Colors.white),
          ),
        ]
      ),
      controller
    ),
    swipeCard(
      textButtonGradient(
        Text("Buy me a coffee", style: GoogleFonts.robotoMono(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.white),),
        generateRandomColorPalette(colorPaletteColorCount), 
        () => launchUrl(Uri.parse("https://www.buymeacoffee.com/mrsinho"))
      ),
      Text(
        "Leaving a tip is greatly appreciated!",
        style: TextStyle(fontSize: bodyFontSize, color: Colors.white),
      ),
      controller
    )
  ];

  CardSwiper swiper = CardSwiper(
      cardsCount: cards.length,
      controller: controller,
      allowedSwipeDirection: AllowedSwipeDirection.only(up: false, down: false, left: true, right: true),
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
        return cards[index];
    }
  );

  double minWidth  = 420;
  double minHeight = 180;

  SizedBox sizedBox = SizedBox(
    width: minWidth,
    height: minHeight,
    child: Card(
      child: swiper,
    ),
  );

  Align align = Align(
    alignment: Alignment.center,
    child: sizedBox,
  );

  double dragHandleWidth = 50;

  Padding dragHandle = Padding(
    padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width - dragHandleWidth) / 2, top: 14),
    child: Container(
      width: dragHandleWidth,
      height: 5,
      decoration: BoxDecoration(
        color: getCurrentThemePalette().quaternaryForegroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
    ),
);


  SlidingUpPanel panel = SlidingUpPanel(
    panel: align,
    minHeight: minHeight / 4,
    maxHeight: minHeight,
    color: Colors.transparent,
    boxShadow: [ BoxShadow(color: Colors.transparent) ],
    header: dragHandle
  );

  return panel;
  
}

Widget swipeCard(Widget title, Widget body, CardSwiperController controller) {

  Row topRow = Row(
    children: [
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: title
        ),
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.arrow_right_rounded, color: Colors.white),
            onPressed: () => controller.swipe(CardSwiperDirection.left)
          )
        ),
      )
    ],
  );

  Padding pad = Padding(
    padding: EdgeInsetsGeometry.all(8),
    child: Column(
      children: [
        topRow,
        Padding(
          padding: EdgeInsetsGeometry.only(left: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: body
          )
        )
      ],
    ),
  );

  List<Color> brightGradientColors = generateRandomColorPalette(3).asColors;
  List<Color> dimGradientColors = [];

  double dimFactor = 0.15;
  double satFactor = 0.05;

  if (isThemeBright()) {
    dimFactor = 0.5;
    satFactor = 0.3;
  }

  for (Color color in brightGradientColors) {
    Color dimColor = Color.fromARGB(255, (255 * dimFactor * color.r).toInt(), (255 * dimFactor * color.g).toInt(), (255 * dimFactor * color.b).toInt());
    dimColor = HSLColor.fromColor(dimColor).withSaturation(satFactor).toColor();
    dimGradientColors.add(dimColor);
  }

  Container container = Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: dimGradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: pad
  );

  return container;

}