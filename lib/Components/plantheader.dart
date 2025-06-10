import 'package:flutter/material.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/plant.dart';

class PlantHeader extends StatefulWidget {
  const PlantHeader({
    super.key,
    required this.plants,
    required this.groupingfn,
    required this.displayName,
  });

  final List<Plant> plants;
  final dynamic groupingfn;
  final String displayName;

  @override
  State<PlantHeader> createState() => _PlantHeaderState();
}

class _PlantHeaderState extends State<PlantHeader> {
  @override
  Widget build(BuildContext context) {
    List<String> outlist = getplantnames(widget.plants);
    outlist.insert(0, "മുഴുവൻ പട്ടിക");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 8.5,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 10,
          direction: Axis.vertical,
          clipBehavior: Clip.antiAlias,
          children:
              outlist.map((String plant) {
                return ActionChip.elevated(
                  label: Text(plant),
                  backgroundColor:
                      plant == widget.displayName
                          ? Theme.of(context).colorScheme.primaryContainer
                          : plant == "മുഴുവൻ പട്ടിക"
                          ? Theme.of(context).colorScheme.tertiaryContainer
                          : Theme.of(context).colorScheme.secondaryContainer,
                  onPressed: () {
                    widget.groupingfn(plant);
                  },
                  elevation: 2,
                  shadowColor: Theme.of(context).colorScheme.primary,
                );
              }).toList(),
        ),
      ),
    );
  }
}
