import 'package:flutter/material.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/plant.dart';

class BigHeroCard extends StatefulWidget {
  const BigHeroCard({
    super.key,
    required this.plant,
    required this.updatehandle,
  });

  final Plant plant;
  final dynamic updatehandle;

  @override
  State<BigHeroCard> createState() => _BigHeroCardState();
}

class _BigHeroCardState extends State<BigHeroCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height) / 2,
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
              widget.plant.plantname,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          if (widget.plant.plantdetails.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                widget.plant.plantdetails,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.bottomLeft,
            child: RichText(
              text: TextSpan(
                text: "തീയതി :",
                style: Theme.of(context).textTheme.headlineSmall,
                children: [
                  widget.plant.plantdate.isNotEmpty
                      ? TextSpan(
                        text:
                            " ${widget.plant.plantdate.substring(8, 10)} ${widget.plant.plantdate.substring(5, 7)} ${widget.plant.plantdate.substring(0, 4)}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                      : TextSpan(
                        text: "",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 20),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.plant.plantdate == ""
                    ? FilledButton(
                      onPressed: null,
                      style: FilledButton.styleFrom(
                        shape: CircleBorder(),
                        // padding: EdgeInsets.all(20),
                      ),
                      // style: ButtonStyle(
                      //   shape: WidgetStateProperty.all(CircleBorder()),
                      //   padding: WidgetStateProperty.all(EdgeInsets.all(15)),
                      //   backgroundColor: WidgetStateProperty.all(
                      //     Colors.blue,
                      //   ), // <-- Button color
                      // ),
                      child: Icon(Icons.edit),
                    )
                    : FilledButton(
                      onPressed: () {
                        widget.updatehandle(widget.plant);
                      },
                      style: FilledButton.styleFrom(
                        shape: CircleBorder(),
                        // padding: EdgeInsets.all(20),
                      ),
                      child: Icon(Icons.edit),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
