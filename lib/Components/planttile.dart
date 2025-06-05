import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:plantapp/Data/plant.dart';

/// This is the UI of a single [Plant] TILE
/// multiple of these instances are created with to form a long list of plants
class PlantTile extends StatefulWidget {
  PlantTile({
    Key? key,
    required this.plant,
    required this.onPlantOrgChange,
    required this.heroDisplay,
    required this.displayPlantName,
  }) : super(key: ObjectKey(plant));

  final Plant plant;
  final dynamic onPlantOrgChange;
  final dynamic heroDisplay;
  final String displayPlantName;

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
    final pendingDays = ((to.difference(from).inHours / 24) * -1).ceil();

    return GestureDetector(
      onTap: () {
        widget.heroDisplay(widget.plant);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          // ],
          // borderRadius: BorderRadius.circular(20.0),
          // color:
          //     widget.plant.plantname.trim() == widget.displayPlantName.trim()
          //         ? Theme.of(context).colorScheme.secondaryContainer
          //         : Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.energy_savings_leaf,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: SingleChildScrollView(
                              child: Text(
                                // widget.plant.plantname.length > 13
                                //     ? '${widget.plant.plantname.substring(0, 13)}...'
                                //     : widget.plant.plantname,
                                widget.plant.plantname,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      text: "$day.",
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: "$month.$year",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        widget.onPlantOrgChange(widget.plant);
                      },
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Material(
              color: Theme.of(context).colorScheme.surfaceDim,
              shape: BeveledRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primaryFixed,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.justify,
                  widget.plant.plantdetails,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text(
                    textAlign: TextAlign.justify,
                    widget.plant.plantid,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
