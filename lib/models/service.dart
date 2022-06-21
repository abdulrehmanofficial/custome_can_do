// To parse this JSON data, do
//
//     final service = serviceFromJson(jsonString);

import 'dart:convert';

List<Service> serviceFromJson(String str) =>
    List<Service>.from(json.decode(str).map((x) => Service.fromJson(x)));

String serviceToJson(List<Service> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Service {
  Service({
    required this.status,
    required this.serviceId,
    required this.latlong,
    required this.startingPrice,
    required this.categoryName,
    required this.categoryId,
    required this.subcategories,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.location,
    required this.address,
    required this.mobile,
    required this.image,
    required this.onlineStatus,
  });

  String status;
  String serviceId;
  String latlong;
  String startingPrice;
  String categoryName;
  String categoryId;
  List<Subcategory> subcategories;
  String userId;
  String firstName;
  String lastName;
  String email;
  String location;
  String address;
  String mobile;
  String image;
  String onlineStatus;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
      status: json["status"],
      serviceId: json["service_id"],
      latlong: json["latlong"],
      startingPrice: json["starting_price"],
      categoryName: json["category_name"],
      categoryId: json["category_id"],
      subcategories: List<Subcategory>.from(
          json["subcategories"].map((x) => Subcategory.fromJson(x))),
      userId: json["user_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      location: json["location"],
      address: json["address"],
      mobile: json["mobile"],
      image: json["image"],
      onlineStatus: json["online_status"]);

  Map<String, dynamic> toJson() => {
        "status": status,
        "service_id": serviceId,
        "latlong": latlong,
        "starting_price": startingPrice,
        "category_name": categoryName,
        "category_id": categoryId,
        "subcategories":
            List<dynamic>.from(subcategories.map((x) => x.toJson())),
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "location": location,
        "address": address,
        "mobile": mobile,
        "image": image,
        "online_status": onlineStatus,
      };
}

class Subcategory {
  Subcategory({
    required this.subcategoryId,
    required this.subcategoryName,
  });

  String subcategoryId;
  String subcategoryName;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        subcategoryId: json["subcategory_id"],
        subcategoryName: json["subcategory_name"],
      );

  Map<String, dynamic> toJson() => {
        "subcategory_id": subcategoryId,
        "subcategory_name": subcategoryName,
      };
}
