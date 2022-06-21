import 'dart:convert';
import 'dart:io';
import 'package:customer_can_do/models/category.dart';
import 'package:customer_can_do/models/change_pass_model.dart';
import 'package:customer_can_do/models/email_verify.dart';
import 'package:customer_can_do/models/forgot_pass_model.dart';
import 'package:customer_can_do/models/orders.dart';
import 'package:customer_can_do/models/register_res.dart';
import 'package:customer_can_do/models/reviews.dart';
import 'package:customer_can_do/models/service.dart';
import 'package:customer_can_do/network/constant.dart';
import 'package:http/http.dart' as http;

import 'package:customer_can_do/models/user.dart';

class ApiRequest {
  ApiRequest();

  Future<User?> signInCall(String _email, String _password) async {
    var url = Uri.parse(Constants.baseURL + Constants.sigin);
    var response =
        await http.post(url, body: {'email': _email, 'password': _password});

    if (response.statusCode == 200) {
      final user = userFromJson(response.body);
      User usr = user.first;
      if(usr.userType=="2"){
        Constants().saveUserData(response.body);
        Constants().saveUserInCahe(usr);
      }
      else{
        throw Exception('Failed to signin');
      }
     /* if (usr.status == "true") {
        Constants().saveUserData(response.body);
        Constants().saveUserInCahe(usr);
      }*/
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }


  Future<User?> editProfile(String firstName,String lastName,String address,String mobile,File? image,String userId) async {
    var url = Uri.parse(Constants.baseURL + Constants.editProfile);


    List<int> list=[];
    String base64Image = base64Encode(image?.readAsBytesSync()??list);
    var response = await http.post(
        url,
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'location': "moc",
          'address': address,
          'mobile': mobile,
          'image': base64Image,
          'user_id': userId
        }).catchError((onError){
      print("error: "+onError.toString());
    });

    if (response.statusCode == 200) {
      final user = userFromJson(response.body);
      User usr = user.first;
      /* if (usr.status == "true") {
        Constants().saveUserInCahe(usr);
        Constants().saveUserData(response.body);
      }*/
      Constants().saveUserInCahe(usr);
      Constants().saveUserData(response.body);
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to Edit Profile');
    }
  }


   addPlayerIdToApi(String userID,String playerId) async {
    var url = Uri.parse(Constants.baseURL + Constants.addPlayerId);


    List<int> list=[];

    var response = await http.post(
        url,
        body: {
          'user_id': userID,
          'player_id': playerId,
        }).catchError((onError){
      print("error: "+onError.toString());
    });

    if (response.statusCode == 200) {
     /* final user = userFromJson(response.body);
      User usr = user.first;
      *//* if (usr.status == "true") {
        Constants().saveUserInCahe(usr);
        Constants().saveUserData(response.body);
      }*//*
      Constants().saveUserInCahe(usr);
      Constants().saveUserData(response.body);
      return usr;*/
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to Update Player Id');
    }
  }

  Future<RegisterRes> rgisterCall(
      String first_name,
      String last_name,
      String _email,
      String _password,
      String location,
      String address,
      String mobile,
      String imagebase64) async {
    var url = Uri.parse(Constants.baseURL + Constants.rigister);
    var response = await http.post(url, body: {
      'first_name': first_name,
      'last_name': last_name,
      'location': location,
      'address': address,
      'mobile': mobile,
      'approved_status': '1',
      'user_type': '2',
      'image': imagebase64,
      'email': _email,
      'password': _password
    });

    if (response.statusCode == 200) {
      final user = registerResFromJson(response.body);
      RegisterRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  Future<VerifyEmail?> emailVerifyCall(String _email) async {
    var url = Uri.parse(Constants.baseURL + Constants.verify_email);
    var response = await http
        .post(url, body: {'email': _email, 'verification_status': "1"});

    if (response.statusCode == 200) {
      final user = verifyEmailFromJson(response.body);
      VerifyEmail usr = user.first;
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  Future<ForgotPassModel?> forgotPassCall(String _email) async {
    var url = Uri.parse(Constants.baseURL + Constants.forgotPass);
    var response = await http.post(url, body: {'email': _email});

    if (response.statusCode == 200) {
      final user = forgotPassModelFromJson(response.body);
      ForgotPassModel usr = user.first;
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  Future<ChangePassModel?> changePassCall(String _email, String _pass) async {
    var url = Uri.parse(Constants.baseURL + Constants.changePass);
    var response =
        await http.post(url, body: {'email': _email, "password": _pass});

    if (response.statusCode == 200) {
      final user = changePassModelFromJson(response.body);
      ChangePassModel usr = user.first;
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  Future<List<Categories>?> getCategory() async {
    var url = Uri.parse(Constants.baseURL + Constants.getCategory);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final catsjson = categoriesFromJson(response.body);

      List<Categories> cats = catsjson;

      return cats;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// get my services

  Future<List<Service>?> getMySeriveCall(String catId) async {
    var url = Uri.parse(Constants.baseURL + Constants.services);
    var response = await http.post(url, body: {
      'category_id': catId,
    });

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      if (parsed[0]["status"] == "true") {
        final user = serviceFromJson(response.body);
        List<Service> reg = user;
        return reg;
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// create order

  Future<RegisterRes?> createOderCall(String traderId, String customerId,
      String catId, String price, String latlong, String address) async {
    var url = Uri.parse(Constants.baseURL + Constants.createOrder);
    var response = await http.post(url, body: {
      'trader_id': traderId,
      'customer_id': customerId,
      'category_id': catId,
      'price': price,
      'latlong': latlong,
      'address': address
    });

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      if (parsed[0]["status"] == "true") {
        final user = registerResFromJson(response.body);
        RegisterRes reg = user.first;
        return reg;
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// get orders
  Future<List<Orders>?> getOrdersCall(String userId, String orderStatus) async {
    var url = Uri.parse(Constants.baseURL + Constants.getOrders);
    var response = await http.post(url, body: {
      'user_id': userId,
      'user_type': "3",
      'order_status': orderStatus
    });

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      if (parsed[0]["status"] == "true") {
        final user = ordersFromJson(response.body);
        List<Orders> reg = user;
        return reg;
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// complete
  Future<RegisterRes> completeOrderCall(String orderId, String price) async {
    var url = Uri.parse(Constants.baseURL + Constants.completeOrder);
    var response =
        await http.post(url, body: {'order_id': orderId, 'price': price});

    if (response.statusCode == 200) {
      final user = registerResFromJson(response.body);
      RegisterRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// addReview
  Future<RegisterRes> addReview(String customerId, String traderId,
      String stars, String message, String givenBy) async {
    var url = Uri.parse(Constants.baseURL + Constants.addReview);
    var response = await http.post(url, body: {
      'customer_id': customerId,
      'trader_id': traderId,
      'stars': stars,
      'message': message,
      'given_by': givenBy
    });

    if (response.statusCode == 200) {
      final review = registerResFromJson(response.body);
      RegisterRes reg = review.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to add review');
    }
  }

  /// getTraderReviews
  Future<List<Reviews>> getTraderReviews(String userId) async {
    userId = '21';

    var url = Uri.parse(Constants.baseURL + Constants.getTraderReviews);
    var response = await http.post(url, body: {'user_id': userId});

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    print(parsed);

    if (parsed[0]["status"] == "true") {
      final revs = reviewsFromJson(response.body);
      List<Reviews> reviews = revs;
      return reviews;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to get reviews');
    }
  }
}
