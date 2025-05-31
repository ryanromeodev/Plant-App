import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          MediaQuery.of(context).orientation == Orientation.portrait
              ? Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(10),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  widget.plant.plantname,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              )
              : Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(10),
                child: Text(
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  widget.plant.plantname,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
          widget.plant.plantdetails.isNotEmpty
              ? MediaQuery.of(context).orientation == Orientation.portrait
                  ? SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: SingleChildScrollView(
                      child: Text(
                        widget.plant.plantdetails,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  )
                  : SizedBox(
                    child: SingleChildScrollView(
                      child: Text(
                        maxLines: 1,
                        widget.plant.plantdetails,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  )
              : SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: SingleChildScrollView(
                  child: Text(
                    "വിവരങ്ങൾ നൽകിയിട്ടില്ല",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
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
            margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.plant.plantdate == ""
                    ? FloatingActionButton(
                      onPressed: null,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Icon(Icons.edit_off),
                    )
                    //  FilledButton(
                    //   onPressed: null,
                    //   style: FilledButton.styleFrom(shape: CircleBorder()),
                    //   child: Icon(Icons.edit),
                    // )
                    : FloatingActionButton(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        widget.updatehandle(widget.plant);
                      },
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
