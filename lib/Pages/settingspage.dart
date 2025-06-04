import 'package:flutter/material.dart';
import 'package:plantapp/Components/wastecard.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Data/strings.dart';

class Settings extends StatefulWidget {
  Settings({super.key, required this.trashlist, required this.plants});

  List<Plant> trashlist;
  final List<Plant> plants;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Plant displayPlant = Plant(
    plantid: "",
    plantname: "ചെടികളുടെ പേര്",
    plantdetails: "വിവരങ്ങൾ",
    // plantdate: DateTime.now().toString().substring(0, 10),
    plantdate: "",
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                bool downloadsuccess = await saveToDownloads(
                  context,
                  widget.plants,
                  plantdownloadfile,
                );
                if (context.mounted) {
                  downloadsuccess
                      ? snackbarfun(context, "Downloaded ആയിരിക്കുന്നു")
                      : snackbarfun(context, "Download ചെയ്യാൻ കഴിഞ്ഞില്ല");
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              WasteCard(plant: displayPlant),
              plantListBuilder(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      showDialogConfirmation(context);
                    },
                    child: const Text('Clear'),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showDialogConfirmation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ശ്രദ്ധിക്കുക"),
          content: Text("ഈ ചെടികള്‍ തിരിച്ചു എടുക്കാൻ സാധിക്കില്ല"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                PlantData().deleteJson(trashfile);
                setState(() {
                  widget.trashlist = [];
                });
                // Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  SizedBox plantListBuilder() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      height:
          orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height / 5
              : MediaQuery.of(context).size.height / 2,
      child: GridView.count(
        crossAxisCount: 1,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        scrollDirection: Axis.horizontal,
        children:
            widget.trashlist.map((Plant plant) {
              return InkWell(
                onTap: () {
                  setState(() {
                    displayPlant = plant;
                  });
                },
                child: ListTile(
                  iconColor: Theme.of(context).colorScheme.primary,
                  leading: Icon(Icons.eco),
                  title: Text(plant.plantname),
                  subtitle: Text(plant.plantdetails),
                ),
              );
            }).toList(),
      ),
    );
  }
}
