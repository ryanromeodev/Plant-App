import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Components/theme.dart';
import 'package:plantapp/Components/bigherocard.dart';
import 'package:plantapp/Components/plantlistheading.dart';
import 'package:plantapp/Components/planttile.dart';
import 'package:plantapp/Data/routingfunctions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

///The [_HomePageState] have the [initState] function where the program tries
///to read a text file and populate the data or else create a new text file for
///storing the newly populated data
class _HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Plant displayPlant = Plant(
    plantid: "",
    plantname: "ചെടികളുടെ പേര്",
    plantdetails: "വിവരങ്ങൾ",
    plantdate: "",
  );
  String day = "", month = "", year = "";
  Icon changinIcon = Icon(Icons.light_mode);
  List<Plant> plist = [];
  List<Plant> trashList = [];

  @override
  initState() {
    _initializeNotifications();
    tz.initializeTimeZones();
    plantDataLoad();
    super.initState();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );
    await _notificationsPlugin.initialize(settings);
  }

  /// Scheduled Notification
  scheduledNotification(
    String title,
    String body,
    int id,
    int day,
    int second,
  ) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(
        Duration(
          seconds: second,
          hours: 6, //morning 6 after 00:00
          days: day,
        ),
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    print("here2");
  }

  //TODO : Future Scope

  // Future<void> _deleteNotificationChannel() async {
  //   const String channelId = 'your channel id';
  //   await _notificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin
  //       >()
  //       ?.deleteNotificationChannel(channelId);

  //   await showDialog<void>(
  //     context: context,
  //     builder:
  //         (BuildContext context) => AlertDialog(
  //           content: const Text('Channel with id $channelId deleted'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  ///[plantDataLoad] Loads the [Plant] Data to a [plist] which could be
  ///used throughout the program instance
  Future<void> plantDataLoad() async {
    List<Plant> inputPlantList = await PlantData().getplantData;
    // List<Plant> inputTrashList = await PlantData().gettrashData;
    List<Plant> inputTrashList = [];
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
          IconButton(
            icon: const Icon(Icons.android),
            onPressed: () {
              print("here");
              _HomePageState().scheduledNotification(
                plist[0].plantname,
                plist[0].plantdate,
                1,
                0,
                2,
              );
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
            // BigHeroCard(plant: displayPlant, updatehandle: updateHandler),
            PlantListHeading(todisplay: "ചെടികളുടെ പേരുകൾ"),
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
              plant.plantid,
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

  Container plantListBuilder() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.0),
        color: Theme.of(context).colorScheme.surface,
      ),
      height:
          Orientation.portrait == orientation
              ? MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).size.height / 5)
              : MediaQuery.of(context).size.height / 2,
      child: Scrollbar(
        thickness: 10,
        radius: Radius.circular(2),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          scrollDirection: Axis.vertical,
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
      ),
    );
  }

  removeUnwantedDate(List<Plant> plants) {
    List<Plant> bufftrash = [];
    plist.forEach((plant) {
      int pendingDays = pendingdays(plant.plantdate);
      if (pendingDays < 0) {
        bufftrash.add(plant);
      }
    });
    setState(() {
      trashList.addAll(bufftrash);
      plist.removeWhere((e) => bufftrash.contains(e));
      plantSorter(plist, trashList);
    });
  }

  updateHandler(Plant plant) async {
    Plant outPlant;
    String id, name, details, date;
    (outPlant, id, name, details, date) = await updatePlantPage(context, plant);
    if (name.isEmpty) {
      removePlantItem(plist, outPlant);
    } else {
      updatePlantItem(outPlant, id, name, details, date);
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
            plantid: "",
            plantname: "ചെടികളുടെ പേര്",
            plantdetails: "വിവരങ്ങൾ",
            plantdate: "",
          );
    });
  }

  updatePlantItem(
    Plant plant,
    String plantid,
    String updatedPlantname,
    String updatedPlantDetails,
    String date,
  ) {
    removePlantItem(plist, plant);
    addPlantItem(plist, plantid, updatedPlantname, updatedPlantDetails, date);
    resetHeroname();
  }

  removePlantItem(List<Plant> plist, Plant plant) {
    String id = plant.plantid;
    setState(() {
      plist.removeWhere((plant) => plant.plantid == id);
      plantSorter(plist, trashList);
      resetHeroname();
    });
  }

  ///Addding a new [Plant]
  addPlantItem(
    List<Plant> plist,
    String id,
    String name,
    String details,
    String date,
  ) {
    setState(() {
      plist.add(
        Plant(
          plantid: id,
          plantname: name,
          plantdetails: details,
          plantdate: date,
        ),
      );
      plantSorter(plist, trashList);
    });
    int notificationdate = pendingdays(date) - 2; //notifies 2 days before
    if (notificationdate >= 0) {
      // notify
      _HomePageState().scheduledNotification(
        name,
        date,
        int.parse(id), //#id gets random, not mapping, just push
        // notificationdate,
        0,
        5,
      );
    }
  }
}
