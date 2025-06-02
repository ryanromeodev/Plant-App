import 'package:flutter/material.dart';
import 'package:plantapp/Components/wastecard.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/plant.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required this.trashlist, required this.plants});

  final List<Plant> trashlist;
  final List<Plant> plants;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Plant displayPlant = Plant(
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
              onPressed: () {
                saveToDownloads(widget.plants, "plantlist.json");
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
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox plantListBuilder() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      height:
          orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height / 5
              : MediaQuery.of(context).size.height / 2,
      // width:
      //     orientation == Orientation.portrait
      //         ? MediaQuery.of(context).size.width / 4
      //         : MediaQuery.of(context).size.width / 2,
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
