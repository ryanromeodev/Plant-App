import 'package:flutter/material.dart';
import 'package:plantapp/Data/data.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/UI/bigherocard.dart';
import 'package:plantapp/UI/plantlistheading.dart';
import 'package:plantapp/UI/planttile.dart';
import 'package:plantapp/Data/fabtestfun.dart';

class PlantOrg extends StatefulWidget {
  const PlantOrg({super.key});

  @override
  State<PlantOrg> createState() => _PlantOrgState();
}

///The [_PlantOrgState] have the [initState] function where the program tries
///to read a text file and populate the data or else create a new text file for
///storing the newly populated data
class _PlantOrgState extends State<PlantOrg> {
  final TextEditingController _textEditingController1 = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  late String plantBufferDate = DateTime.now().toString();

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

  String heroDisplayPlantName = "ചെടികളുടെ പേര്";
  String heroDisplayPlantDetails = "വിവരങ്ങൾ";
  String heroDisplayPlantDate = "തീയതി";

  String day = "", month = "", year = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              saveToDownloads(plist, "plantlist.json");
            },
          ),
        ],
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 35.0,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        scrolledUnderElevation: 0.0,
        // surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          BigHeroCard(
            heroDisplayPlantName: heroDisplayPlantName,
            heroDisplayPlantDetails: heroDisplayPlantDetails,
            day: day,
            month: month,
            year: year,
          ),
          PlantListHeading(),
          plantListBuilder(),
          SizedBox(height: 100),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: displayDialog,
        // onPressed: () {
        //   fileTest(context);
        // },
        tooltip: "add plant",
        child: const Icon(Icons.add),
      ),
    );
  }

  Expanded plantListBuilder() {
    return Expanded(
      flex: 1,
      // child: CarouselView.weighted(
      //   controller: CarouselController(initialItem: 1),
      //   scrollDirection: Axis.horizontal,
      //   itemSnapping: true,
      //   flexWeights: const <int>[1, 2, 8, 2, 1],
      //   children:
      //       plist.map((Plant plant) {
      //         return PlantTile(
      //           plant: plant,
      //           onPlantOrgChange: _handlePlantOrgChange,
      //           heroDisplay: _heroDisplayFunction,
      //         );
      //       }).toList(),
      // ),
      child: Container(
        color: Colors.transparent,
        child: GridView.count(
          crossAxisCount: 1,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          scrollDirection: Axis.horizontal,
          children:
              plist.map((Plant plant) {
                return PlantTile(
                  plant: plant,
                  onPlantOrgChange: handlePlantOrgChange,
                  heroDisplay: heroDisplayFunction,
                );
              }).toList(),
        ),
      ),
    );
  }

  heroDisplayFunction(Plant plant) {
    setState(() {
      heroDisplayPlantName = plant.plantname;
      heroDisplayPlantDetails = plant.plantdetails;
      heroDisplayPlantDate = plant.plantdate;
      year = heroDisplayPlantDate.substring(0, 4);
      month = heroDisplayPlantDate.substring(5, 7);
      day = heroDisplayPlantDate.substring(8, 10);
    });
  }

  updatePlantItem(
    Plant plant,
    String updatedPlantname,
    String updatedPlantDetails,
    String date,
  ) {
    setState(() {
      plist.remove(plant);
      plist.add(
        Plant(
          plantname: updatedPlantname,
          plantdetails: updatedPlantDetails,
          plantdate: date,
        ),
      );
      _textEditingController1.clear();
      _textEditingController2.clear();
    });
    plantSorter(plist);
  }

  removePlantItem(Plant plant) {
    setState(() {
      plist.remove(plant);
      _textEditingController1.clear();
      _textEditingController2.clear();
      plantSorter(plist);
    });
  }

  handlePlantOrgChange(Plant plant) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modify plants"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textEditingController1,
                decoration: InputDecoration(hintText: plant.plantname),
              ),
              TextField(
                controller: _textEditingController2,
                decoration: InputDecoration(hintText: plant.plantdetails),
              ),
              ElevatedButton(
                onPressed: () => selectDate(context, plant),
                child: const Text('Set Date'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                removePlantItem(plant);
              },
              child: const Text("Remove"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                updatePlantItem(
                  plant,
                  _textEditingController1.text.isEmpty
                      ? plant.plantname
                      : _textEditingController1.text,
                  _textEditingController2.text.isEmpty
                      ? plant.plantdetails
                      : _textEditingController2.text,
                  plantBufferDate,
                );
              },
              child: const Text("Update"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  ///Addding a new [Plant]
  addPlantItem(String name, String details) {
    setState(() {
      plist.add(
        Plant(
          plantname: name,
          plantdetails: details,
          plantdate: DateTime.now().toString(),
        ),
      );
      plantSorter(plist);
    });
    _textEditingController1.clear();
    _textEditingController2.clear();
  }

  ///Selecting a date for the [Plant]
  selectDate(BuildContext context, Plant plant) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2021, 7, 12),
      firstDate: DateTime(1999),
      lastDate: DateTime(2032),
    );
    setState(() {
      plantBufferDate = newSelectedDate.toString();
    });
  }

  /// the dialog window caused by clicking on the FAB button
  displayDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false, //user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add new Item"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textEditingController1,
                decoration: const InputDecoration(hintText: "add new plants"),
              ),
              TextField(
                controller: _textEditingController2,
                decoration: const InputDecoration(
                  hintText: "details of the plant",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: to add date while adding plant
                addPlantItem(
                  _textEditingController1.text,
                  _textEditingController2.text,
                );
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
