///This is how a single [Plant] is stored in the entire program.
///It have its name as [plantname], its details regarding
///it as [plantdetails] and the date as [plantdate]
class Plant {
  Plant({
    required this.plantid,
    required this.plantname,
    required this.plantdetails,
    required this.plantdate,
  });

  String plantid;
  String plantname;
  String plantdetails;
  String plantdate;

  @override
  String toString() {
    return "id: $plantid name :$plantname date :$plantdate details :$plantdetails";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["plantid"] = plantid;
    data["plantname"] = plantname;
    data["plantdetails"] = plantdetails;
    data["plantdate"] = plantdate;
    return data;
  }
}
