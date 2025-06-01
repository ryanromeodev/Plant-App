import 'package:flutter/material.dart';

class PlantListHeading extends StatelessWidget {
  const PlantListHeading({super.key, required this.todisplay});

  final String todisplay;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      // margin: EdgeInsets.symmetric(horizontal: 10),
      child: Text(todisplay, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
