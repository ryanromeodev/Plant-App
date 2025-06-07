import 'package:flutter/material.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/functions.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/Components/theme.dart';
import 'package:plantapp/Components/plantlistheading.dart';
import 'package:plantapp/Components/planttile.dart';
import 'package:plantapp/Data/routingfunctions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plantapp/Components/plantheader.dart';
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

  // Plant displayPlant = Plant(
  //   plantid: "292",
  //   plantname: "",
  //   plantdetails: "",
  //   plantdate: "",
  // );
  String day = "", month = "", year = "", displayname = "", displayid = "";
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
    int hour,
    int second,
  ) async {
    var t = tz.TZDateTime.now(tz.local).add(
      Duration(
        seconds: second,
        hours: hour, //morning 6 after 00:00
        days: day,
      ),
    );
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      t,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
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
            icon: const Icon(Icons.delete),
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
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              _HomePageState().scheduledNotification(
                "test",
                "test",
                2,
                0,
                0,
                3,
              );
            },
          ),
        ],
        title: Row(
          children: [
            Icon(Icons.home),
            SizedBox(width: 5),
            Text('തുടക്കം', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),

        scrolledUnderElevation: 0.0,
        // surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          PlantHeader(plist: plist),
          Container(
            height: 1.0, // Line thickness
            color: Theme.of(context).colorScheme.primary, // Line color
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          ),
          PlantListHeading(todisplay: "ചെടികളുടെ പേരുകൾ"),
          Expanded(child: plantListBuilder()),
        ],
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
              plant.plantnote,
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.0),
        color: Theme.of(context).colorScheme.surface,
      ),
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
              plist.map((Plant plant) {
                return PlantTile(
                  plant: plant,
                  onPlantOrgChange: updateHandler,
                  heroDisplay: groupselectfn,
                  displayPlantName: displayname,
                  displayplantid: displayid,
                );
              }).toList(),
        ),
      ),
    );
  }

  updateHandler(Plant plant) async {
    Plant outPlant;
    String id, name, details, date, note;
    (outPlant, id, name, details, date, note) = await updatePlantPage(
      context,
      plant,
    );
    if (id.isEmpty) {
      removePlantItem(plist, outPlant);
    } else if (date != "") {
      updatePlantItem(outPlant, id, name, details, date, note);
    }
  }

  groupselectfn(Plant plant) {
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
        plantSorter(plist, trashList);
        trashList.add(plant);
      });
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
          plantnote: note, //TODO : Add note date
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
        6,
        5,
      );
    }
  }
}
