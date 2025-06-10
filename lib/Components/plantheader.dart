import 'package:flutter/material.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Data/strings.dart';

class PlantHeader extends StatefulWidget {
  const PlantHeader({
    super.key,
    required this.plants,
    required this.groupingfn,
    required this.displayName,
    required this.malayalam,
  });

  final List<Plant> plants;
  final dynamic groupingfn;
  final String displayName;
  final bool malayalam;

  @override
  State<PlantHeader> createState() => _PlantHeaderState();
}

class _PlantHeaderState extends State<PlantHeader> {
  @override
  Widget build(BuildContext context) {
    List<String> outlist = getplantnames(widget.plants);
    outlist.insert(0, widget.malayalam ? mmuzhuvanpattika : muzhuvanpattika);
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
                  label: Text(
                    plant,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  backgroundColor:
                      plant == widget.displayName
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withRed(230).withAlpha(150)
                          : plant ==
                              (widget.malayalam
                                  ? mmuzhuvanpattika
                                  : muzhuvanpattika)
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withBlue(150).withAlpha(150)
                          : Theme.of(
                            context,
                          ).colorScheme.primary.withRed(100).withAlpha(150),
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
