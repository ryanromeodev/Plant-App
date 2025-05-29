import 'package:flutter/material.dart';
import 'package:plantapp/Data/functions.dart';

class BigHeroCard extends StatelessWidget {
  const BigHeroCard({
    super.key,
    required this.heroDisplayPlantName,
    required this.heroDisplayPlantDetails,
    required this.day,
    required this.month,
    required this.year,
  });

  final String heroDisplayPlantName;
  final String heroDisplayPlantDetails;
  final String day;
  final String month;
  final String year;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 10.0),
          ],
          gradient: LinearGradient(
            colors: getColorsList,
            transform: GradientRotation(0.5),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.all(10),
              child: Text(
                heroDisplayPlantName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            if (heroDisplayPlantDetails.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  heroDisplayPlantDetails,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                  // TextStyle(
                  //   fontWeight: FontWeight.normal,
                  //   color: textwhite,
                  //   fontSize: herotextsize,
                  // ),
                ),
              ),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomLeft,
              child: RichText(
                text: TextSpan(
                  text: "തീയതി :",
                  style: Theme.of(context).textTheme.headlineSmall,
                  // style: TextStyle(
                  //   fontSize: herotextsize,
                  //   color: textwhite,
                  //   fontWeight: FontWeight.normal,
                  //   fontStyle: FontStyle.normal,
                  // ),
                  children: [
                    TextSpan(
                      text: " $day $month $year",
                      style: Theme.of(context).textTheme.headlineSmall,
                      // TextStyle(
                      //   fontSize: herotextsize,
                      //   color: textwhite,
                      //   fontWeight: FontWeight.normal,
                      //   fontStyle: FontStyle.normal,
                      // ),
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
