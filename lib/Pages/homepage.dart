import 'package:flutter/material.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/notification.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Components/theme.dart';
import 'package:plantapp/Components/plantlistheading.dart';
import 'package:plantapp/Components/planttile.dart';
import 'package:plantapp/Data/routingfunctions.dart';
import 'package:plantapp/Components/plantheader.dart';
import 'package:plantapp/Data/strings.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

///The [_HomePageState] have the [initState] function where the program tries
///to read a text file and populate the data or else create a new text file for
///storing the newly populated data
class _HomePageState extends State<HomePage> {
  String day = "", month = "", year = "", displayname = "", displayid = "";
  Icon changinIcon = Icon(Icons.light_mode);
  List<Plant> plist = [];
  List<Plant> trashList = [];
  bool fulllist = true;
  bool malayalam = true;
  @override
  initState() {
    initializeNotifications();
    tz.initializeTimeZones();
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
        // backgroundColor: Colors.transparent,
        // elevation: 0.0,
        actions: [
          if (plist.isEmpty)
            IconButton(
              icon: const Icon(Icons.file_open),
              onPressed: () async {
                List<Plant> plants = await loadtestdata();
                setState(() {
                  plist = plants;
                  plantSorter(plist, trashList);
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {
              setState(() {
                malayalam = !malayalam;
              });
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
            icon: const Icon(Icons.settings),
            onPressed: () async {
              List<Plant> trash = await displaySettingsPage(
                context,
                trashList,
                plist,
              );
              setState(() {
                trashList = trash;
              });
            },
          ),
        ],
        title: Row(
          children: [
            Icon(Icons.home),
            SizedBox(width: 5),
            Text(
              malayalam ? mhometitle : hometitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          PlantListHeading(todisplay: malayalam ? mchediname : chediname),
          PlantHeader(
            plants: plist,
            displayName: displayname,
            groupingfn: groupselectbynamefn,
            malayalam: malayalam,
          ),
          Container(
            height: 2.0, // Line thickness
            color: Theme.of(context).colorScheme.primary, // Line color
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Expanded(child: plantListBuilder()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Plant plant = await addingPlantPage(context, malayalam);
          if (plant.plantname.isNotEmpty) {
            addPlantItem(
              plist,
              plant.plantid,
              plant.plantname,
              plant.plantdetails,
              plant.plantdate,
              plant.plantnote,
            );
          }
        },
        heroTag:
            "add", // need to add this as only one FAB per route is possible
        child: const Icon(Icons.add),
      ),
    );
  }

  Container plantListBuilder() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(26.0)),
      height: MediaQuery.of(context).size.height,
      child: Scrollbar(
        thickness: 10,
        radius: Radius.circular(2),
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          scrollDirection: Axis.vertical,
          children:
              !fulllist
                  ? plist.map((Plant plant) {
                    if (displayname.trim() == plant.plantname.trim()) {
                      return PlantTile(
                        plant: plant,
                        onPlantOrgChange: updateHandler,
                        heroDisplay: groupselectbyplantfn,
                        displayPlantName: displayname,
                        displayplantid: displayid,
                        malayalam: malayalam,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }).toList()
                  : plist.map((Plant plant) {
                    return PlantTile(
                      plant: plant,
                      onPlantOrgChange: updateHandler,
                      heroDisplay: groupselectbyplantfn,
                      displayPlantName: displayname,
                      displayplantid: displayid,
                      malayalam: malayalam,
                    );
                  }).toList(),
        ),
      ),
    );
  }

  updateHandler(Plant plant, bool malayalam) async {
    Plant outPlant;
    String id, name, details, date, note;
    (outPlant, id, name, details, date, note) = await updatePlantPage(
      context,
      plant,
      malayalam,
    );
    if (id.isEmpty) {
      removePlantItem(plist, outPlant);
    } else if (date != "") {
      updatePlantItem(outPlant, id, name, details, date, note);
    }
  }

  groupselectbynamefn(String pname) {
    setState(() {
      displayname = pname;
      if (fulllist) {
        fulllist = false;
      }
      if (pname == (malayalam ? mmuzhuvanpattika : muzhuvanpattika)) {
        if (!fulllist) {
          fulllist = true;
        }
      }
    });
  }

  groupselectbyplantfn(Plant plant) {
    setState(() {
      displayname = plant.plantname;
      displayid = plant.plantid;
    });
  }

  updatePlantItem(
    Plant plant,
    String plantid,
    String updatedPlantname,
    String updatedPlantDetails,
    String date,
    String note,
  ) {
    removePlantItem(plist, plant);
    addPlantItem(
      plist,
      plantid,
      updatedPlantname,
      updatedPlantDetails,
      date,
      note,
    );
  }

  removePlantItem(List<Plant> plist, Plant plant) {
    String id = plant.plantid;
    if (id.isNotEmpty) {
      setState(() {
        plist.removeWhere((plant) => plant.plantid == id);
        trashList.add(plant);
        plantSorter(plist, trashList);
      });
      removeNotification(plant);
    }
  }

  ///Addding a new [Plant]
  addPlantItem(
    List<Plant> plist,
    String id,
    String name,
    String details,
    String date,
    String note,
  ) {
    setState(() {
      plist.add(
        Plant(
          plantid: id,
          plantname: name,
          plantdetails: details,
          plantdate: date,
          plantnote: note,
        ),
      );
      plantSorter(plist, trashList);
    });
    setNotification(
      Plant(
        plantid: id,
        plantname: name,
        plantdetails: details,
        plantdate: date,
        plantnote: note,
      ),
    );
  }
}
