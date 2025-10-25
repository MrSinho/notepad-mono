import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/app_data.dart';
import '../backend/utils/color_utils.dart';

import 'ui_utils.dart';


Widget swipeCardsBuilder() {

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
      style: TextStyle(fontSize: bodyFontSize),
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
        style: TextStyle(fontSize: bodyFontSize),
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
            style: TextStyle(fontSize: bodyFontSize),
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
        style: TextStyle(fontSize: bodyFontSize),
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
    child: swiper,
  );

  Align align = Align(
    alignment: Alignment.center,
    child: sizedBox,
  );

  return align;
  
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
            icon: Icon(Icons.arrow_right_rounded),
            onPressed: () => controller.swipe(CardSwiperDirection.left)
          )
        ),
      )
    ],
  );

  Padding pad = Padding(
    padding: EdgeInsetsGeometry.all(16),
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

  List<Color> brightGradientColors = generateRandomColorPalette(2).asColors;
  List<Color> dimGradientColors = [];

  double dimFactor = 0.15;
  for (Color color in brightGradientColors) {
    Color dimColor = Color.fromARGB(255, (255 * dimFactor * color.r).toInt(), (255 * dimFactor * color.g).toInt(), (255 * dimFactor * color.b).toInt());
    dimColor = HSLColor.fromColor(dimColor).withSaturation(0.05).toColor();
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