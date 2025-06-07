import 'package:flutter/material.dart';
import 'package:plantapp/Data/plant.dart';

class PlantHeader extends StatefulWidget {
  const PlantHeader({
    super.key,
    required this.plants,
    required this.groupingfn,
  });

  final List<Plant> plants;
  final dynamic groupingfn;

  @override
  State<PlantHeader> createState() => _PlantHeaderState();
}

class _PlantHeaderState extends State<PlantHeader> {
  @override
  Widget build(BuildContext context) {
    List<String> outlist = getplantnames(widget.plants);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
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
                  onPressed: () {
                    widget.groupingfn(plant);
                  },
                  elevation: 1,
                );
              }).toList(),
        ),
      ),
    );
  }
}

List<String> getplantnames(List<Plant> plist) {
  List<String> outlist = [];
  for (Plant p in plist) {
    if (!outlist.contains(p.plantname)) {
      outlist.add(p.plantname);
    }
  }
  return outlist;
}
