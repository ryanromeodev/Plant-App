import 'package:flutter/material.dart';

class PlantListHeading extends StatelessWidget {
  const PlantListHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(10),
      child: Text(
        "ചെടികളുടെ പേര്",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
