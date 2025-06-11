import 'package:flutter/material.dart';
import 'package:plantapp/Components/plantlistheading.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/notification.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Data/strings.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
    required this.trashlist,
    required this.plants,
    required this.malayalam,
  });

  final List<Plant> trashlist;
  final List<Plant> plants;
  final bool malayalam;
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
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.settings),
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
                widget.malayalam ? msettings : settings,
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
              style: IconButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
              style: IconButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
              Container(margin: EdgeInsets.symmetric(vertical: 5.0)),
              PlantListHeading(
                todisplay: widget.malayalam ? mdeleted : deleted,
              ),
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
          title: Text(widget.malayalam ? mcareful : careful),
          content: Text(widget.malayalam ? mcannotbeundone : cannotbeundone),
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
              ? MediaQuery.of(context).size.height / 4
              : MediaQuery.of(context).size.height / 2,
      child: Scrollbar(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          scrollDirection: Axis.vertical,
          children:
              trashes.map((Plant plant) {
                return ListTile(
                  iconColor: Theme.of(context).colorScheme.primary,
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("assets/topfe.png"),
                  ),
                  title: Row(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          plant.plantname.length > 15
                              ? plant.plantname.substring(0, 15)
                              : plant.plantname,
                        ),
                      ),
                      Text(" ${plant.plantdate}"),
                    ],
                  ),
                  subtitle: Text(
                    "details: ${plant.plantdetails}, notification date: ${plant.plantnote}",
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
