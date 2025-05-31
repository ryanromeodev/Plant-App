import 'package:flutter/material.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Components/theme.dart';
import 'package:plantapp/Components/bigherocard.dart';
import 'package:plantapp/Components/plantlistheading.dart';
import 'package:plantapp/Components/planttile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

///The [_HomePageState] have the [initState] function where the program tries
///to read a text file and populate the data or else create a new text file for
///storing the newly populated data
class _HomePageState extends State<HomePage> {
  List<Plant> plist = [];

  @override
  initState() {
    plantDataLoad();
    super.initState();
  }

  ///[plantDataLoad] Loads the [Plant] Data to a [plist] which could be
  ///used throughout the program instance
  Future<void> plantDataLoad() async {
    List<Plant> inputPlantList = await PlantData().getplantData;
    plantSorter(inputPlantList);
    setState(() {
      plist = inputPlantList;
    });
  }

  Plant displayPlant = Plant(
    plantname: "ചെടികളുടെ പേര്",
    plantdetails: "വിവരങ്ങൾ",
    plantdate: DateTime.now().toString().substring(0, 10),
  );

  String day = "", month = "", year = "";
  Icon changinIcon = Icon(Icons.light_mode);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              removeUnwantedDate(plist);
            },
          ),
          IconButton(
            icon: changinIcon,
            onPressed:
                () => {
                  Theme.of(context).brightness == Brightness.light
                      ? {
                        Adenium.of(context).changeTheme(ThemeMode.dark),
                        changinIcon = Icon(Icons.dark_mode),
                      }
                      : {
                        Adenium.of(context).changeTheme(ThemeMode.light),
                        changinIcon = Icon(Icons.light_mode),
                      },
                },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              saveToDownloads(plist, "plantlist.json");
            },
          ),
        ],
        title: Text('തുടക്കം', style: Theme.of(context).textTheme.displaySmall),
        scrolledUnderElevation: 0.0,
        // surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BigHeroCard(plant: displayPlant, updatehandle: updateHandler),
            PlantListHeading(todisplay: "ചെടികളുടെ പേരുകൾ"),
            plantListBuilder(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Plant plant = await addingPlantPage(context);
          if (plant.plantname.isNotEmpty) {
            addPlantItem(plant.plantname, plant.plantdetails, plant.plantdate);
          }
        },
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  SizedBox plantListBuilder() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      height:
          orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height / 4
              : MediaQuery.of(context).size.height / 2,
      child: GridView.count(
        crossAxisCount: 1,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        scrollDirection: Axis.horizontal,
        children:
            plist.map((Plant plant) {
              return PlantTile(
                plant: plant,
                onPlantOrgChange: updateHandler,
                heroDisplay: heroDisplayFunction,
              );
            }).toList(),
      ),
    );
  }

  removeUnwantedDate(List<Plant> plants) {
    for (Plant plant in plants) {
      final String year = plant.plantdate.substring(0, 4);
      final String month = plant.plantdate.substring(5, 7);
      final String day = plant.plantdate.substring(8, 10);
      //the birthday's date
      final from = DateTime(int.parse(year), int.parse(month), int.parse(day));
      final to = DateTime.now();
      final int pendingDays = to.difference(from).inDays * -1;
      // plist.removeWhere((plant) => plant.plantname == name);
      if (pendingDays > 0) {
        print(plant);
      }
    }
  }

  updateHandler(Plant plant) async {
    Plant outPlant;
    String name, details, date;
    (outPlant, name, details, date) = await updatePlantPage(context, plant);
    // print("from root $outPlant,$name,$details$date");
    if (name.isEmpty) {
      // Remove
      removePlantItem(outPlant);
    } else {
      updatePlantItem(outPlant, name, details, date);
    }
  }

  heroDisplayFunction(Plant plant) {
    setState(() {
      displayPlant = plant;
    });
  }

  updatePlantItem(
    Plant plant,
    String updatedPlantname,
    String updatedPlantDetails,
    String date,
  ) {
    removePlantItem(plant);
    setState(() {
      plist.add(
        Plant(
          plantname: updatedPlantname,
          plantdetails: updatedPlantDetails,
          plantdate: date,
        ),
      );
    });
    plantSorter(plist);
    resetHeroname();
  }

  removePlantItem(Plant plant) {
    String name = plant.plantname;
    setState(() {
      plist.removeWhere((plant) => plant.plantname == name);
      plantSorter(plist);
      resetHeroname();
    });
  }

  resetHeroname() {
    setState(() {
      displayPlant =
          displayPlant = Plant(
            plantname: "ചെടികളുടെ പേര്",
            plantdetails: "വിവരങ്ങൾ",
            plantdate: "",
          );
    });
  }

  ///Addding a new [Plant]
  addPlantItem(String name, String details, String date) {
    setState(() {
      plist.add(Plant(plantname: name, plantdetails: details, plantdate: date));
      plantSorter(plist);
    });
  }
}
