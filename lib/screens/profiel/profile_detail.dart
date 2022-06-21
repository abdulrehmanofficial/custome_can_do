import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:customer_can_do/models/user.dart';
import 'package:customer_can_do/network/constant.dart';
import 'package:customer_can_do/screens/login_screen.dart';
import 'package:customer_can_do/screens/profiel/edit_profile.dart';
import 'package:flutter/material.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  User? userData;
  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Profile"),
        actions: [
          // ignore: deprecated_member_use
          // FlatButton(
          //     onPressed: () {},
          //     child: TextButton(
          //       child: Text(
          //         'Logout',
          //         style: TextStyle(
          //             fontFamily: 'Futura', fontSize: 20, color: Colors.white),
          //       ),
          //       onPressed: () {
          //         Constants().logout();
          //         Navigator.pushAndRemoveUntil(
          //           context,
          //           MaterialPageRoute(builder: (context) => LoginScreen()),
          //           (Route<dynamic> route) => false,
          //         );
          //       },
          //     )),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  userData?.image??"",
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          _firstName(context, "First Name", userData?.firstName ?? "N/A"),
          _firstName(context, "Last Name", userData?.lastName ?? "N/A"),
          _firstName(context, "Contact Number", userData?.mobile ?? "N/A"),
          _firstName(context, "Email", userData?.email ?? "N/A"),
          Container(
            margin: EdgeInsets.all(20),
            child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  EditProfile(userData)),
                );
                },
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
          )
        ],
      ),
    );
  }

  Widget _firstName(BuildContext context, String title, String name) {
    return Container(
      margin: EdgeInsets.only(top: 20,left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  void getData() async {
    var user = await Constants().getUserData();
    if (user != null) {
      print(user);
      setState(() {
        userData = user;
      });
    }
  }
}
