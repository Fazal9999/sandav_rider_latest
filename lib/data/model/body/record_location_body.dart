class RecordLocationBody {
  String token;
  double longitude;
  double latitude;
  String location;
  int vehicle_id;

  RecordLocationBody({this.token, this.longitude, this.latitude, this.location,this.vehicle_id});

  RecordLocationBody.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    longitude = json['longitude'].toDouble();
    latitude = json['latitude'].toDouble();
    location = json['location'];
    vehicle_id=json['vehicle_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['location'] = this.location;
    data['vehicle_id'] = this.vehicle_id;
    return data;
  }
}
