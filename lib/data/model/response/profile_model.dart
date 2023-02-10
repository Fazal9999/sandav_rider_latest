class ProfileModel {
  int id;
  int vehicle_id;
  String fName;
  String lName;
  String phone;
  String email;
  String identityNumber;
  String identityType;
  String identityImage;
  String image;
  String fcmToken;
  int zoneId;
  int active;
  double avgRating;
  int ratingCount;
  int memberSinceDays;
  int orderCount;
  int todaysOrderCount;
  int thisWeekOrderCount;
  double cashInHands;
  int earnings;
  String type;
  double balance;
  double todaysEarning;
  double thisWeekEarning;
  double thisMonthEarning;
  String createdAt;
  String updatedAt;
  String is_vehicle_responsibility;
  String is_criminal_bg_check;
  String is_total_amount;
  String is_paid_every_week;
  String is_paid_per_km;
  String is_max_order;
  String is_track_event;
  String is_max_waiting_period;
  String is_version_seven_plus;
  String is_agree_terms;
  String is_agree_privacy;
  String vehicle_license_images;

  ProfileModel({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.identityNumber,
    this.identityType,
    this.identityImage,
    this.image,
    this.fcmToken,
    this.zoneId,
    this.active,
    this.avgRating,
    this.memberSinceDays,
    this.orderCount,
    this.todaysOrderCount,
    this.thisWeekOrderCount,
    this.cashInHands,
    this.ratingCount,
    this.createdAt,
    this.updatedAt,
    this.earnings,
    this.type,
    this.balance,
    this.todaysEarning,
    this.vehicle_id,
    this.thisWeekEarning,
    this.thisMonthEarning,
    this.is_vehicle_responsibility,
    this.is_criminal_bg_check,
    this.is_total_amount,
    this.is_paid_every_week,
    this.is_paid_per_km,
    this.is_max_order,
    this.is_track_event,
    this.is_max_waiting_period,
    this.is_version_seven_plus,
    this.is_agree_terms,
    this.is_agree_privacy,
    this.vehicle_license_images,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    identityNumber = json['identity_number'];
    identityType = json['identity_type'];
    identityImage = json['identity_image'];
    image = json['image'];
    fcmToken = json['fcm_token'];
    zoneId = json['zone_id'];
    active = json['active'];
    avgRating = json['avg_rating'].toDouble();
    ratingCount = json['rating_count'];
    memberSinceDays = json['member_since_days'];
    orderCount = json['order_count'];
    todaysOrderCount = json['todays_order_count'];
    thisWeekOrderCount = json['this_week_order_count'];
    cashInHands = json['cash_in_hands'].toDouble();
    earnings = json['earning'];
    type = json['type'];
    balance = json['balance'].toDouble();
    todaysEarning = json['todays_earning'].toDouble();
    thisWeekEarning = json['this_week_earning'].toDouble();
    thisMonthEarning = json['this_month_earning'].toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vehicle_id = json['vehicle_id'];

    is_vehicle_responsibility = json['is_vehicle_responsibility'];
    is_criminal_bg_check = json['is_criminal_bg_check'];
    is_total_amount = json['is_total_amount'];
    is_paid_every_week = json['is_paid_every_week'];
    is_paid_per_km = json['is_paid_per_km'];
    is_max_order = json['is_max_order'];
    is_track_event = json['is_track_event'];

    is_max_waiting_period = json['is_max_waiting_period'];
    is_version_seven_plus = json['is_version_seven_plus'];
    is_agree_terms = json['is_agree_terms'];
    is_agree_privacy = json['is_agree_privacy'];
    vehicle_license_images = json['vehicle_license_images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_id'] = this.vehicle_id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['identity_number'] = this.identityNumber;
    data['identity_type'] = this.identityType;
    data['identity_image'] = this.identityImage;
    data['image'] = this.image;
    data['fcm_token'] = this.fcmToken;
    data['zone_id'] = this.zoneId;
    data['active'] = this.active;
    data['avg_rating'] = this.avgRating;
    data['rating_count'] = this.ratingCount;
    data['member_since_days'] = this.memberSinceDays;
    data['order_count'] = this.orderCount;
    data['todays_order_count'] = this.todaysOrderCount;
    data['this_week_order_count'] = this.thisWeekOrderCount;
    data['cash_in_hands'] = this.cashInHands;
    data['earning'] = this.earnings;
    data['balance'] = this.balance;
    data['type'] = this.type;
    data['todays_earning'] = this.todaysEarning;
    data['this_week_earning'] = this.thisWeekEarning;
    data['this_month_earning'] = this.thisMonthEarning;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    data['is_vehicle_responsibility'] = this.is_vehicle_responsibility;
    data['is_criminal_bg_check']= this.is_criminal_bg_check;;
    data['is_total_amount']= this.is_total_amount;;
    data['is_paid_every_week']= this.is_paid_every_week;;
    data['is_paid_per_km']= this.is_paid_per_km;;
    data['is_max_order']= this.is_max_order;;
    data['is_track_event']= this.is_track_event;;
    data['is_max_waiting_period']= this.is_max_waiting_period;;
    data['is_version_seven_plus']= this.is_version_seven_plus;;
    data['is_agree_terms']= this.is_agree_terms;;
    data['is_agree_privacy']= this.is_agree_privacy;;
    data['vehicle_license_images']= this.vehicle_license_images;;

    return data;
  }
}
