import 'package:flutter/material.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Components/theme.dart';
import 'package:plantapp/Components/bigherocard.dart';
import 'package:plantapp/Components/plantlistheading.dart';
import 'package:plantapp/Components/planttile.dart';
import 'package:plantapp/Data/routingfunctions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

///The [_HomePageState] have the [initState] function where the program tries
///to read a text file and populate the data or else create a new text file for
///storing the newly populated data
class _HomePageState extends State<HomePage> {
  Plant displayPlant = Plant(
    plantname: "ചെടികളുടെ പേര്",
    plantdetails: "വിവരങ്ങൾ",
    // plantdate: DateTime.now().toString().substring(0, 10),
    plantdate: "",
  );
  String day = "", month = "", year = "";
  Icon changinIcon = Icon(Icons.light_mode);
  List<Plant> plist = [];
  List<Plant> trashList = [];

  @override
  initState() {
    plantDataLoad();
    super.initState();
  }

  ///[plantDataLoad] Loads the [Plant] Data to a [plist] which could be
  ///used throughout the program instance
  Future<void> plantDataLoad() async {
    List<Plant> inputPlantList = await PlantData().getplantData;
    List<Plant> inputTrashList = await PlantData().gettrashData;
    plantSorter(inputPlantList, inputTrashList);
    setState(() {
      plist = inputPlantList;
      trashList = inputTrashList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
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
            icon: const Icon(Icons.settings),
            onPressed: () {
              displaySettingsPage(context, trashList, plist);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PlantListHeading(todisplay: "ചെടികളുടെ പേരുകൾ"),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    // color: Colors.red,
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: SizedBox(
                      child: GestureDetector(
                        onTap: () {
                          removeUnwantedDate(plist);
                        },
                        child: Icon(Icons.refresh),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            plantListBuilder(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Plant plant = await addingPlantPage(context);
          if (plant.plantname.isNotEmpty) {
            addPlantItem(
              plist,
              plant.plantname,
              plant.plantdetails,
              plant.plantdate,
            );
          }
        },
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        heroTag:
            "add", // need to add this as only one FAB per route is possible
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
                displayPlant: displayPlant,
              );
            }).toList(),
      ),
    );
  }

  removeUnwantedDate(List<Plant> plants) {
    List<Plant> bufftrash = [];
    plist.forEach((plant) {
      final String year = plant.plantdate.substring(0, 4);
      final String month = plant.plantdate.substring(5, 7);
      final String day = plant.plantdate.substring(8, 10);
      //the birthday's date
      final from = DateTime(int.parse(year), int.parse(month), int.parse(day));
      final to = DateTime.now();
      final int pendingDays = to.difference(from).inDays * -1;
      if (pendingDays < 0) {
        bufftrash.add(plant);
      }
    });
    print("trash $bufftrash");
    setState(() {
      trashList.addAll(bufftrash);
      plist.removeWhere((e) => bufftrash.contains(e));
      plantSorter(plist, trashList);
    });

    print("plist $plist");
  }

  updateHandler(Plant plant) async {
    Plant outPlant;
    String name, details, date;
    (outPlant, name, details, date) = await updatePlantPage(context, plant);
    if (name.isEmpty) {
      removePlantItem(plist, outPlant);
    } else {
      updatePlantItem(outPlant, name, details, date);
    }
  }

  heroDisplayFunction(Plant plant) {
    setState(() {
      displayPlant = plant;
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

  updatePlantItem(
    Plant plant,
    String updatedPlantname,
    String updatedPlantDetails,
    String date,
  ) {
    removePlantItem(plist, plant);
    setState(() {
      plist.add(
        Plant(
          plantname: updatedPlantname,
          plantdetails: updatedPlantDetails,
          plantdate: date,
        ),
      );
    });
    plantSorter(plist, trashList);
    resetHeroname();
  }

  removePlantItem(List<Plant> plist, Plant plant) {
    String name = plant.plantname;
    setState(() {
      plist.removeWhere((plant) => plant.plantname == name);
      plantSorter(plist, trashList);
      resetHeroname();
    });
  }

  ///Addding a new [Plant]
  addPlantItem(List<Plant> plist, String name, String details, String date) {
    setState(() {
      plist.add(Plant(plantname: name, plantdetails: details, plantdate: date));
      plantSorter(plist, trashList);
    });
  }
}
