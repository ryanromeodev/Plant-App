import 'package:flutter/material.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Components/plantlistheading.dart';

class Addplant extends StatefulWidget {
  const Addplant({super.key});

  @override
  State<Addplant> createState() => _AddplantState();
}

class _AddplantState extends State<Addplant> {
  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  String name = "",
      details = "",
      date = DateTime.now().toString().substring(0, 10);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'ചെടി ചേർക്കുക',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(
                  context,
                  Plant(plantname: "", plantdetails: "", plantdate: ""),
                );
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
                    fillColor: Colors.white,
                    hintMaxLines: 3,
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
                            Navigator.pop(
                              context,
                              Plant(
                                plantname: nameController.text,
                                plantdetails:
                                    detailsController.text.isNotEmpty
                                        ? detailsController.text
                                        : "വിവരങ്ങൾ നൽകിയിട്ടില്ല",
                                plantdate: date,
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
                          Plant(plantname: "", plantdetails: "", plantdate: ""),
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

  void selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2032),
    );
    setState(() {
      date = newSelectedDate.toString().substring(0, 10);
    });
  }
}
