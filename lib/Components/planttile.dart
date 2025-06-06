import 'package:flutter/material.dart';
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
    required this.displayPlantName,
    required this.displayplantid,
  }) : super(key: ObjectKey(plant));

  final Plant plant;
  final dynamic onPlantOrgChange;
  final dynamic heroDisplay;
  final String displayPlantName;
  final String displayplantid;

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
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          // ],
          // borderRadius: BorderRadius.circular(20.0),
          // color:
          //     widget.plant.plantname.trim() == widget.displayPlantName.trim()
          //         ? Theme.of(context).colorScheme.error
          //         : Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onPlantOrgChange(widget.plant);
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 20,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage:
                          (aim[int.parse(widget.plant.plantid) % 10]),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Material(
                  elevation: 4,
                  color:
                      widget.displayPlantName.trim() ==
                              widget.plant.plantname.trim()
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "${widget.plant.plantid} ${widget.plant.plantname}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
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
                if (widget.plant.plantid == widget.displayplantid)
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.chevron_left),
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
            SizedBox(height: 15),
            Material(
              color:
                  widget.displayPlantName.trim() ==
                          widget.plant.plantname.trim()
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface,
              shape: BeveledRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primaryFixedDim,
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
              ),
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
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
