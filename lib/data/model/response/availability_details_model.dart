import 'package:flutter/widgets.dart';
import 'package:sandav/data/model/response/address_model.dart';
import 'package:sandav/data/model/response/product_model.dart';

class AvailabilityDetailsModel {
  int food_id;
  int restaurant_id;
  int userId;
  double price;
  String status ;
  Product foodDetails;
  AddressModel deliveryAddress;
  double deliveryCharge;
   int quantity;
 double order_amount;
  int deliveryAddressId=null;
 String createdAt;
  String updatedAt;

   String address;
   String latitude;
   String longitude;
   String contactPersonName;
   String contactPersonNumber;
   String addressType;
   String road;
   String house;
   //String scheduleAt;
   String floor;
  AvailabilityDetailsModel(
      {
     this.food_id,
      this.restaurant_id,
      this.userId,
      this.price,
      this.status,
      this.foodDetails,
      this.deliveryAddress,
     this.deliveryCharge,
      this.quantity,
     this.order_amount,
     this.deliveryAddressId,
      this.createdAt,
      this.updatedAt,
        this.address,
        this.latitude,
        this.longitude,
        this.contactPersonName,
        this.contactPersonNumber,
        this.addressType,
       // this.scheduleAt
      });
  AvailabilityDetailsModel.fromJson(Map<String, dynamic> json) {
   // id = json['id'];
    food_id = json['food_id'];
    restaurant_id = json['restaurant_id'];
    userId = json['user_id'];
     status = json['status'];
    price = json['price'].toDouble();
    foodDetails = json['food_details'] != null
        ? new Product.fromJson(json['food_details'])
        : null;
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order_amount=json['order_amount'];
    //scheduleAt=json['schedule_at'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['id'] = this.id;
    data['food_id'] = this.food_id;
    data['user_id'] = this.userId;
    data['price'] = this.price;
    if (this.foodDetails != null) {
      data['food_details'] = this.foodDetails.toJson();
    }
    data['quantity'] = this.quantity;
    data['order_amount'] = this.order_amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['restaurant_id'] = this.restaurant_id;
    data['status'] = this.status;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
  //  data['schedule_at'] = this.scheduleAt;

    return data;
  }
}

 