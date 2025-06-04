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
    required this.displayPlant,
  }) : super(key: ObjectKey(plant));

  final Plant plant;
  final dynamic onPlantOrgChange;
  final dynamic heroDisplay;
  final Plant displayPlant;

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
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ],
          borderRadius: BorderRadius.circular(26.0),
          color:
              widget.plant.plantname.trim() ==
                      widget.displayPlant.plantname.trim()
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: RichText(
                      text: TextSpan(
                        text: day,
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: " $month $year",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.plant.plantname.length > 40
                          ? '${widget.plant.plantname.substring(0, 40)}...'
                          : widget.plant.plantname,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Text(
                textAlign: TextAlign.center,
                widget.plant.plantdetails,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () {
                  widget.onPlantOrgChange(widget.plant);
                },
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
