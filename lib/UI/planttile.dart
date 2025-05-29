import 'package:flutter/material.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Data/strings.dart';

/// This is the UI of a single [Plant] TILE
/// multiple of these instances are created with to form a long list of plants
class PlantTile extends StatefulWidget {
  PlantTile({
    Key? key,
    required this.plant,
    required this.onPlantOrgChange,
    required this.heroDisplay,
  }) : super(key: ObjectKey(plant));

  final Plant plant;
  final dynamic onPlantOrgChange;
  final dynamic heroDisplay;

  @override
  State<PlantTile> createState() => _PlantTileState();
}

class _PlantTileState extends State<PlantTile> {
  // @override
  @override
  Widget build(BuildContext context) {
    final String year = widget.plant.plantdate.substring(0, 4);
    final String month = widget.plant.plantdate.substring(5, 7);
    final String day = widget.plant.plantdate.substring(8, 10);
    //the birthday's date
    final from = DateTime(int.parse(year), int.parse(month), int.parse(day));
    final to = DateTime.now();
    final pendingDays = to.difference(from).inDays;

    return GestureDetector(
      onDoubleTap: () {
        widget.onPlantOrgChange(widget.plant);
      },
      onTap: () {
        widget.heroDisplay(widget.plant);
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(16.0),
        // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ],
          borderRadius: BorderRadius.circular(26.0),
          gradient: LinearGradient(
            begin: getAlignments.first,
            end: getAlignments.last,
            colors: getColorsList,
            tileMode: TileMode.clamp,
            transform: GradientRotation(0.5),
          ),
        ),

        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  text: day,
                  style: TextStyle(
                    fontSize: normaltextsize,
                    color: textwhite,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
                  children: [
                    TextSpan(
                      text: " $month $year",
                      style: TextStyle(
                        fontSize: normaltextsize,
                        color: textwhite,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.plant.plantname,
                style: TextStyle(
                  fontSize: normaltextsize,
                  color: textwhite,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(0.1),
              margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26.0),
                color: Colors.transparent.withAlpha(20),
              ),
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "ഇനി",
                  style: TextStyle(fontSize: 16.0, color: textwhite),
                  children: [
                    TextSpan(
                      text: " $pendingDays",
                      style: TextStyle(color: textwhite),
                    ),
                    TextSpan(
                      text: " ദിവസം",
                      style: TextStyle(fontSize: 16.0, color: textwhite),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
