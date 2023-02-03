class DeliveryManBody {
  String fName;
  String lName;
  String phone;
  String email;
  String password;
  String identityType;
  String identityNumber;
  String earning;
  String zoneId;
  int vehicle_id;
  String is_criminal_bg_check;
  String is_total_amount;
  String is_paid_every_week;
  String is_vehicle_responsibility;
  String is_paid_per_km;
  String is_max_order;
  String is_track_event;
  String is_max_waiting_period;
  String is_version_seven_plus;
  String is_agree_terms;
  String is_agree_privacy;

  DeliveryManBody({
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.password,
    this.identityType,
    this.identityNumber,
    this.earning,
    this.zoneId,
    this.vehicle_id,
    this.is_criminal_bg_check,
    this.is_total_amount,
    this.is_paid_every_week,
    this.is_vehicle_responsibility,
    this.is_paid_per_km,
    this.is_max_order,
    this.is_track_event,
    this.is_max_waiting_period,
    this.is_version_seven_plus,
    this.is_agree_terms,
    this.is_agree_privacy,
  });

  DeliveryManBody.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    identityType = json['identity_type'];
    identityNumber = json['identity_number'];
    earning = json['earning'];
    zoneId = json['zone_id'];

    vehicle_id= json['vehicle_id'];
    is_criminal_bg_check= json['is_criminal_bg_check'];
    is_total_amount= json['is_total_amount'];
    is_paid_every_week= json['is_paid_every_week'];
    is_vehicle_responsibility= json['is_vehicle_responsibility'];
    is_paid_per_km= json['is_paid_per_km'];
    is_max_order= json['is_max_order'];
    is_track_event= json['is_track_event'];
    is_max_waiting_period= json['is_max_waiting_period'];
    is_version_seven_plus= json['is_version_seven_plus'];
    is_agree_terms= json['is_agree_terms'];
    is_agree_privacy= json['is_agree_privacy'];


  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['identity_type'] = this.identityType;
    data['identity_number'] = this.identityNumber;
    data['earning'] = this.earning;
    data['zone_id'] = this.zoneId;
    data['vehicle_id'] = this.vehicle_id.toString();
    data['is_criminal_bg_check'] = this.is_criminal_bg_check;
    data['is_total_amount'] =  this.is_total_amount;
    data['is_paid_every_week'] =this.is_paid_every_week;
    data['is_vehicle_responsibility'] = this.is_vehicle_responsibility;
    data['is_paid_per_km'] =  this.is_paid_per_km;
    data['is_max_order'] =  this.is_max_order;
    data['is_track_event'] = this.is_track_event;
    data['is_max_waiting_period'] =  this.is_max_waiting_period;
    data['is_version_seven_plus'] =  this.is_version_seven_plus;
    data['is_agree_terms'] =  this.is_agree_terms;
    data['is_agree_privacy'] =  this.is_agree_privacy;
    return data;
  }
}
