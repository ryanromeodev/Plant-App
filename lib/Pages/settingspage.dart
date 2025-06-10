import 'package:flutter/material.dart';
import 'package:plantapp/Components/plantlistheading.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/notification.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Data/strings.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required this.trashlist, required this.plants});

  final List<Plant> trashlist;
  final List<Plant> plants;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<Plant> trashes = [];
  @override
  initState() {
    trashes = widget.trashlist;
    super.initState();
  }

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
              icon: Icon(Icons.notifications_active),
              onPressed: () {
                for (Plant plant in widget.plants) {
                  scheduledNotification(
                    plant.plantname,
                    plant.plantdetails,
                    int.parse(plant.plantid),
                    0,
                    0,
                    0,
                    10,
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, trashes);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 1.0, // Line thickness
                color: Theme.of(context).colorScheme.primary, // Line color
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              ),
              PlantListHeading(todisplay: "Deleted plants"),
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
                      Navigator.pop(context, trashes);
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                PlantData().deleteJson(trashfile);
                setState(() {
                  trashes = [];
                });
                Navigator.pop(context, trashes);
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
        scrollDirection: Axis.vertical,
        children:
            trashes.map((Plant plant) {
              return ListTile(
                iconColor: Theme.of(context).colorScheme.primary,
                leading: Icon(Icons.eco),
                title: Text(plant.plantname),
                subtitle: Text(plant.plantdetails),
              );
            }).toList(),
      ),
    );
  }
}
