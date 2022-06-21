import 'package:customer_can_do/models/current_user.dart';
import 'package:customer_can_do/models/user.dart';
import 'package:customer_can_do/network/api_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

class Constants {
  Constants();

  static String oneSignalId = "YOUR_ONE_SIGNAL_API_KEY";

  static String baseURL = "YOUR_WEB_API_URL";
  static String rigister = "register";
  static String sigin = "login";
  static String editProfile = "updateProfile";
  static String addPlayerId = "addPlayerId";
  static String verify_email = "verifyEmail";
  static String forgotPass = "forgetPassword";
  static String changePass = "changePassword";
  static String getCategory = "getCategories";
  static String services = "getServices";
  static String createOrder = "createOrder";
  static String getOrders = "myOrders";
  static String completeOrder = "completeOrder";
  static String addReview = "addReview";
  static String getTraderReviews = "getTraderReviews";

  void showalert(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void saveUserData(String jsonstr) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setString('user', jsonstr);
  }

  void saveLatLng(String lat, String lng) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setString('lat', lat);
    sharedUser.setString('lng', lng);
    print("location saved");
  }

  void saveUserInCahe(User user) {
    CurrentUser.id = user.id;
    CurrentUser.firstName = user.firstName;
    CurrentUser.lastName = user.lastName;
    CurrentUser.email = user.email;
    CurrentUser.location = user.location;
    CurrentUser.mobile = user.mobile;
    CurrentUser.image = user.image;
    CurrentUser.userType = user.userType;
  }

  void logout() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    // var jsonstr = userToJson();

    sharedUser.remove('user');
  }

  Future<User?> getUserData() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    String? userMap = sharedUser.getString('user');
    if (userMap != null && userMap != "") {
      User user = userFromJson(userMap).first;
      return user;
    }
    return null;
  }

  /////
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  double calculateDistance(String currentLoc, String otherLoc) {
    late var currArr;
    late var otherArr;
    if(RegExp(r'^[a-z]+$').hasMatch(currentLoc)){
      currArr = ["1234","1234"];
    }
    else{
      currArr = ["1234","1234"];
    }
    if(RegExp(r'^[a-z]+$').hasMatch(otherLoc)){
      otherArr = ["1234","1234"];
    }
    else{
      otherArr = ["1234","1234"];
    }

    double startLat = double.parse(currArr[0]);
    double startLng = double.parse(currArr[1]);
    double endLat = double.parse(otherArr[0]);
    double endLng = double.parse(otherArr[1]);

    var _distance =
    Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
    double distanceInKiloMeters = _distance / 1000;
    double roundDistanceInKM =
    double.parse((distanceInKiloMeters).toStringAsFixed(2));
    return roundDistanceInKM;
  }

  void getAddress(LocationData loc) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(loc.latitude!, loc.longitude!);
    print(placemarks.first.locality);
    CurrentUser.address = placemarks.first.locality;
  }

  updatePlayerId(String userId) async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;

    ApiRequest().addPlayerIdToApi(userId, osUserID??"0").then((user) {

    });

  }

}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }




}
