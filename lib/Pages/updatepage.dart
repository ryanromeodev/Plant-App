import 'package:flutter/material.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Components/plantlistheading.dart';

class UpdatePlant extends StatefulWidget {
  const UpdatePlant({super.key, required this.plant});

  final Plant plant;

  @override
  State<UpdatePlant> createState() => _UpdatePlantState();
}

class _UpdatePlantState extends State<UpdatePlant> {
  final nameController = TextEditingController();
  final detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    oldid = widget.plant.plantid;
    oldname = widget.plant.plantname;
    olddetails = widget.plant.plantdetails;
    olddate = widget.plant.plantdate;
    oldnote = widget.plant.plantnote;
    nameController.text = widget.plant.plantname;
    detailsController.text = widget.plant.plantdetails;
    isChecked =
        widget.plant.plantnote.length > 9 && widget.plant.plantnote.isNotEmpty
            ? true
            : false;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  String oldid = "",
      oldname = "",
      olddetails = "",
      olddate = "",
      oldnote = "",
      name = "",
      details = "";
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
              Icon(Icons.edit_square),
              SizedBox(width: 5),
              Text(
                'ചെടി പുതുക്കുക',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, (
                  Plant(
                    plantid: "",
                    plantname: "",
                    plantdetails: "",
                    plantdate: "",
                    plantnote: "",
                  ),
                  "",
                  "",
                  "",
                  "",
                  "",
                ));
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PlantListHeading(todisplay: "പേര്"),
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
                    hintText: 'പേര് ഇവിടെ എഴുതുക',
                  ),
                ),
              ),
              PlantListHeading(todisplay: "വിവരങ്ങൾ"),
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
                    hintText: 'വിവരങ്ങൾ ഇവിടെ എഴുതുക',
                  ),
                ),
              ),
              PlantListHeading(todisplay: "ഒരു തീയതി തിരഞ്ഞെടുക്കുക"),
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
                      icon: Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                      onPressed: () => selectDate(context),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextButton(
                      onPressed: null,
                      child: Text(widget.plant.plantdate),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  PlantListHeading(todisplay: "നോട്ടിഫിക്കേഷൻ വേണോ?"),
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        widget.plant.plantnote = "";
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
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    nameController.text.length >= 2
                        ? FilledButton(
                          onPressed: () {
                            Navigator.pop(context, (
                              Plant(
                                plantid: oldid,
                                plantname: oldname,
                                plantdetails: olddetails,
                                plantdate: olddate,
                                plantnote: oldnote,
                              ),
                              widget.plant.plantid,
                              nameController.text,
                              detailsController.text.isNotEmpty
                                  ? detailsController.text
                                  : "വിവരങ്ങൾ നൽകിയിട്ടില്ല",
                              widget.plant.plantdate,
                              widget.plant.plantnote,
                            ));
                          },
                          child: const Text('Update'),
                        )
                        : FilledButton(
                          onPressed: null,
                          child: const Text('Update'),
                        ),
                    nameController.text.length >= 2
                        ? FilledButton(
                          onPressed: () {
                            Navigator.pop(context, (
                              Plant(
                                plantid: oldid,
                                plantname: oldname,
                                plantdetails: olddetails,
                                plantdate: olddate,
                                plantnote: oldnote,
                              ),
                              "",
                              "",
                              "",
                              "",
                              "",
                            ));
                          },
                          child: const Text('Remove'),
                        )
                        : FilledButton(
                          onPressed: null,
                          child: const Text('Remove'),
                        ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context, (
                          Plant(
                            plantid: "",
                            plantname: "",
                            plantdetails: "",
                            plantdate: "",
                            plantnote: "",
                          ),
                          "",
                          "",
                          "",
                          "",
                          "",
                        ));
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
          child: TextButton(
            onPressed: null,
            child: Text(widget.plant.plantnote),
          ),
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
        widget.plant.plantdate = newSelectedDate.toString().substring(0, 10);
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
        widget.plant.plantnote = notificationdate.toString().substring(0, 10);
      }
    });
  }
}
