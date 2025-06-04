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

  String oldid = "", oldname = "", olddetails = "", olddate = "";

  @override
  void initState() {
    super.initState();
    oldid = widget.plant.plantid;
    oldname = widget.plant.plantname;
    olddetails = widget.plant.plantdetails;
    olddate = widget.plant.plantdate;
    nameController.text = widget.plant.plantname;
    detailsController.text = widget.plant.plantdetails;
    date = widget.plant.plantdate;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  String name = "",
      details = "",
      date = DateTime.now().toString().substring(0, 10);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'ചെടി പുതുക്കുക',
            style: Theme.of(context).textTheme.displaySmall,
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
                  ),
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
                    child: ElevatedButton(
                      onPressed: () => selectDate(context),
                      child: Text("select date"),
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
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    nameController.text.length >= 2
                        ? FilledButton(
                          onPressed: () {
                            // Close the screen and return "Yep!" as the result.
                            Navigator.pop(context, (
                              Plant(
                                plantid: oldid,
                                plantname: oldname,
                                plantdetails: olddetails,
                                plantdate: olddate,
                              ),
                              widget.plant.plantid,
                              nameController.text,
                              detailsController.text.isNotEmpty
                                  ? detailsController.text
                                  : "വിവരങ്ങൾ നൽകിയിട്ടില്ല",
                              date,
                            ));
                          },
                          // style: FilledButton.styleFrom(
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(5.0),
                          //   ),
                          // ),
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
                              ),
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
                          ),
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
}
