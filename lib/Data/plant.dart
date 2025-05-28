///This is how a single [Plant] is stored in the entire program.
///It have its name as [plantname], its details regarding
///it as [plantdetails] and the date as [plantdate]
class Plant {
  Plant({
    required this.plantname,
    required this.plantdetails,
    required this.plantdate,
  });

  String plantname;
  String plantdetails;
  String plantdate;

  @override
  String toString() {
    return "plant_name :${plantname}plant_date :${plantdate}plant_details :$plantdetails";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["plantname"] = plantname;
    data["plantdetails"] = plantdetails;
    data["plantdate"] = plantdate;
    return data;
  }
}
