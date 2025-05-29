import 'package:flutter/material.dart';
import 'package:plantapp/Data/plant.dart';
import 'package:plantapp/UI/plantlistheading.dart';

class Addplant extends StatefulWidget {
  const Addplant({super.key});

  @override
  State<Addplant> createState() => _AddplantState();
}

class _AddplantState extends State<Addplant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          PlantListHeading(todisplay: "പേര്"),
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 10.0),
              ],
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                transform: GradientRotation(0.5),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'പേര് ഇവിടെ എഴുതുക',
                fillColor: Colors.white,
              ),
            ),
          ),
          PlantListHeading(todisplay: "വിവരങ്ങൾ"),
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 10.0),
              ],
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                transform: GradientRotation(0.5),
              ),
            ),
            child: TextField(
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'വിവരങ്ങൾ ഇവിടെ എഴുതുക',
                fillColor: Colors.white,
                hintMaxLines: 3,
              ),
            ),
          ),
          PlantListHeading(todisplay: "ഒരു തീയതി തിരഞ്ഞെടുക്കുക"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("select date"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text("put date here"),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Close the screen and return "Yep!" as the result.
                    Navigator.pop(
                      context,
                      Plant(
                        plantname: "plantname",
                        plantdetails: "plantdetails",
                        plantdate: DateTime.now().toString(),
                      ),
                    );
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
