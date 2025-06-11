import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Components/plantlistheading.dart';
import 'package:plantapp/Data/strings.dart';

class Addplant extends StatefulWidget {
  const Addplant({super.key, required this.malayalam});
  final bool malayalam;
  @override
  State<Addplant> createState() => _AddplantState();
}

class _AddplantState extends State<Addplant> {
  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  String name = "",
      details = "",
      date = DateTime.now().toString().substring(0, 10),
      note = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () {},
                style: IconButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                widget.malayalam ? madd : add,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          actions: [
            IconButton(
              style: IconButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(
                  context,
                  Plant(
                    plantid: "",
                    plantname: "",
                    plantdetails: "",
                    plantdate: "",
                    plantnote: "",
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(margin: EdgeInsets.symmetric(vertical: 5.0)),
              PlantListHeading(todisplay: widget.malayalam ? mperu : peru),
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: TextField(
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      setState(() {
                        name = text;
                      });
                    }
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    hintText: widget.malayalam ? mhinttextperu : hinttextperu,
                  ),
                ),
              ),
              PlantListHeading(
                todisplay: widget.malayalam ? mvivaranghal : vivaranghal,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: TextField(
                  controller: detailsController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    hintText:
                        widget.malayalam
                            ? mhinttextvivaranghal
                            : hinttextvivaranghal,
                    hintMaxLines: 3,
                  ),
                ),
              ),
              PlantListHeading(
                todisplay: widget.malayalam ? mthiyathi : thiyathi,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => selectDate(context),
                      icon: Icon(
                        Icons.calendar_month,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextButton(onPressed: null, child: Text(date)),
                  ),
                ],
              ),
              Row(
                children: [
                  PlantListHeading(
                    todisplay:
                        widget.malayalam ? mnotificationveno : notificationveno,
                  ),
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        note = "";
                        isChecked = !isChecked;
                      });
                    },
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: notificationBody(context),
                secondChild: PlantListHeading(todisplay: ""),
                crossFadeState:
                    isChecked
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 200),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    nameController.text.length >= 2
                        ? FilledButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              Plant(
                                plantid: Random().nextInt(1000001).toString(),
                                plantname: nameController.text,
                                plantdetails:
                                    detailsController.text.isNotEmpty
                                        ? detailsController.text
                                        : "വിവരങ്ങൾ നൽകിയിട്ടില്ല",
                                plantdate: date,
                                plantnote: note,
                              ),
                            );
                          },
                          child: const Text('Confirm'),
                        )
                        : FilledButton(
                          onPressed: null,
                          child: const Text('Confirm'),
                        ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          Plant(
                            plantid: "",
                            plantname: "",
                            plantdetails: "",
                            plantdate: "",
                            plantnote: "",
                          ),
                        );
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row notificationBody(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: IconButton(
            style: IconButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => selectNote(context),
            icon: Icon(
              Icons.calendar_month,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: TextButton(onPressed: null, child: Text(note)),
        ),
      ],
    );
  }

  void selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2032),
    );
    setState(() {
      if (newSelectedDate != null) {
        date = newSelectedDate.toString().substring(0, 10);
      }
    });
  }

  void selectNote(BuildContext context) async {
    DateTime? notificationdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2032),
    );
    setState(() {
      if (notificationdate != null) {
        note = notificationdate.toString().substring(0, 10);
      }
    });
  }
}
