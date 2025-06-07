import 'package:flutter/material.dart';
import 'package:plantapp/Components/plantlistheading.dart';
import 'package:plantapp/Data/plant.dart';

class PlantHeader extends StatelessWidget {
  const PlantHeader({super.key, required this.plist});

  final List<Plant> plist;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PlantListHeading(todisplay: "numbers"),
        Container(child: PlantListHeading(todisplay: "${plist.length}")),
      ],
    );
  }
}
