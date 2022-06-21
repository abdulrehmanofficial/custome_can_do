import 'dart:math';

import 'package:customer_can_do/models/category.dart';
import 'package:customer_can_do/models/current_user.dart';
import 'package:customer_can_do/network/api_request.dart';
import 'package:customer_can_do/screens/home_page.dart';
import 'package:customer_can_do/screens/profiel/profile_page.dart';
import 'package:customer_can_do/screens/profiel/tasklist_page.dart';
import 'package:customer_can_do/screens/profiel/term_condition_page.dart';
import 'package:customer_can_do/screens/tabs/pages/tabs_page.dart';
import 'package:flutter/material.dart';

import 'package:share/share.dart';
import 'package:package_info/package_info.dart';
import 'package:launch_review/launch_review.dart';

//import 'package:random_color/random_color.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Categories>? cats;
  List<Categories>? catsCopy;
  // RandomColor _randomColor = RandomColor();
  final Random _random = Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Center(child: Text('Home')),
          //backgroundColor: Colors.amberAccent,
          //leading: Icon(Icons.gps_fixed),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              // child: Icon(Icons.notifications),
            )
          ],
        ),
        body: Column(
          children: [_header(context), _categoryListView(context)],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(CurrentUser.firstName ?? ""),
                accountEmail: Text(CurrentUser.email ?? ""),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(CurrentUser.image!),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.home),
                    SizedBox(
                      width: 5,
                    ),
                    const Text('Home'),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.of(context)
                      .pushAndRemoveUntil(new MaterialPageRoute(
                      builder: (BuildContext context) => new TabsPage()), (Route<dynamic> route) => false);
                 /* Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new TabsPage()));*/
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.production_quantity_limits),
                    SizedBox(
                      width: 5,
                    ),
                    const Text('My Orders'),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new TaskListPage()));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.account_box),
                    SizedBox(
                      width: 5,
                    ),
                    const Text('My Profile'),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ProfilePage()));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(
                      width: 5,
                    ),
                    const Text('Invite Friends'),
                  ],
                ),
                onTap: () async {
                  // Update the state of the app
                  // ...
                  // Then close the drawer

                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  String packageName = packageInfo.packageName;

                  Share.share(
                      'check out Can Do Today app here: https://play.google.com/store/apps/details?id=' +
                          packageName,
                      subject: 'Can Do Today App');

                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.star),
                    SizedBox(
                      width: 5,
                    ),
                    const Text('Rate Us'),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  LaunchReview.launch(androidAppId: 'com.hos.customer_cando_today');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.portrait),
                    SizedBox(
                      width: 5,
                    ),
                    const Text('About Us'),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new TermsConditionPage()));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.link),
                    SizedBox(
                      width: 5,
                    ),
                    const Text('Become a Trader'),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer

                  LaunchReview.launch(androidAppId: 'com.ah.can_do_customer');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }

  // gets categories
  void getCats() {
    ApiRequest().getCategory().then((reg) {
      if (reg != null) {
        setState(() {
          cats = reg;
          catsCopy=[];
          catsCopy?.addAll(reg);
        });
      }
    });
  }
  // header

  Widget _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 20),
      height: 160,
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Hi, ${CurrentUser.firstName} ! Welcome Back ",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Container(
              // width: MediaQuery.of(context).size.width - 50,
              // height: 50,
              //color: Colors.red,
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Icon(
                  //   Icons.pin_drop,
                  //   color: Colors.white,
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    CurrentUser.address ?? "",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
            const SizedBox(height: 20),
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 30),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: TextField(
                  onChanged: (text){
                    catsCopy?.clear();
                    if(text.isEmpty){
                      catsCopy?.addAll(cats??[]);
                      setState(() {

                      });
                    }
                    else{
                      for(int i=0; i<(cats?.length??0);i++){
                        if(cats?[i].categoryName.toLowerCase().contains(text.toLowerCase())??false){
                          catsCopy?.add(cats![i]);
                        }
                      }
                      setState(() {

                      });
                    }
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Categories..",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _categoryListView(BuildContext context) {
    return Expanded(
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(catsCopy != null ? catsCopy!.length : 0, (index) {
          return Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  //  color: Colors.red,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new HomePage(catsCopy![index].categoryId)));
                    },
                    child: Container(
                      height: 100,

                      margin: const EdgeInsets.only(
                        left: 5,
                      ),
                      decoration: BoxDecoration(
                          color: (index % 2) == 0
                              ? Colors.blue[300]
                              : Colors.blue[300], //Colors.blue[100],

                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                      //  color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          catsCopy?[index].categoryImage != ""
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(catsCopy![index].categoryImage),
                                )
                              // ? Image.network(
                              //     cats![index].categoryImage,
                              //     height: 40,
                              //   )
                              : Icon(
                                  Icons.search,
                                  color: Theme.of(context).primaryColor,
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: Text(
                                catsCopy?[index].categoryName ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  // backgroundColor: Colors.grey,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
