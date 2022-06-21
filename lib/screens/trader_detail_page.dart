import 'package:customer_can_do/models/current_user.dart';
import 'package:customer_can_do/models/service.dart';
import 'package:customer_can_do/network/api_request.dart';
import 'package:customer_can_do/network/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class TraderDetailPage extends StatefulWidget {
  Service service;
  TraderDetailPage(this.service);

  @override
  _TraderDetailPageState createState() => _TraderDetailPageState();
}

class _TraderDetailPageState extends State<TraderDetailPage> {
  bool isLoading = false;
  var reviews = [];
  bool isLoadingReviews = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: ListView(
        children: [_item(context, widget.service)],
      ),
    );
  }

  Widget _item(BuildContext context, Service service) {
    return Container(
      // width: MediaQuery.of(context).size.width - 50,
      margin: EdgeInsets.all(10),
      //height: 170,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(service.image),
                        // onBackgroundImageError: (context, url, error) => new Icon(Icons.error),
                        onBackgroundImageError: (obj, err) {
                          print(err);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      //color: Colors.red,
                      // width: MediaQuery.of(context).size.width - 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  service.firstName.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Container(
                                //     child: TextButton(
                                //   child: Text(
                                //       "\$ ${service.startingPrice}/hr"), //Icon(Icons.delete),
                                //   onPressed: () {
                                //     // setState(() {
                                //     //   _showItem = !_showItem;
                                //     // });
                                //   },
                                // )
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBarIndicator(
                                  rating: 4,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    '4.0',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  child: Text("\$ ${service.startingPrice}/hr"),
                                ),
                                Text('')
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.pin_drop,
                                ),
                                Text(service.address,
                                    overflow: TextOverflow.ellipsis)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                //_categoryListView(context, service.subcategories)
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
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
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.miscellaneous_services_outlined),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(service.categoryName),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.subdirectory_arrow_right_outlined),
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        margin: EdgeInsets.only(left: 5),
                        child: Text(getSubCats()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: !isLoading
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Are you sure ?'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text(
                                          'Are you sure you want to hire this trader?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      createOrder();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.how_to_reg_outlined),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Text('Hire Now'),
                        )
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                      // fixedSize: Size(150, 30),
                    ),
                  )
                : CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: ElevatedButton(
                  onPressed: () async => {
                    await FlutterPhoneDirectCaller.callNumber(service.mobile)
                  },
                  child: Row(
                    children: [
                      Icon(Icons.call),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text('Call Provider'),
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white,
                    fixedSize: Size(150, 30),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: !isLoadingReviews
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoadingReviews = true;
                          });
                          getTraderReviews();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.reviews),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text('See Reviews'),
                            )
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: Theme.of(context).primaryColor,
                          onPrimary: Colors.white,
                          fixedSize: Size(150, 30),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 50),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
              ),
            ],
          ),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              // Let the ListView know how many items it needs to build.
              itemCount: reviews.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = reviews[index];

                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'].toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBarIndicator(
                            rating: double.parse(item['stars']),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                          Text('(' + item['stars'].toString() + '.0)')
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [Text(item['message'])],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String getSubCats() {
    String cats = "";
    for (var sub in widget.service.subcategories) {
      cats = cats + " ${sub.subcategoryName} , ";
    }
    return cats;
  }

  void createOrder() {
    if (widget.service != null) {
      String currUserId = CurrentUser.id ?? "";
      String loca = CurrentUser.location ?? "";
      String address = CurrentUser.address ?? "";
      ApiRequest()
          .createOderCall(
              widget.service.userId,
              currUserId,
              widget.service.categoryId,
              widget.service.startingPrice,
              loca,
              address)
          .then((reg) {
        if (reg != null) {
          Constants().showalert(reg.message);
        }
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> getTraderReviews() async {
    var url = Uri.parse(Constants.baseURL + Constants.getTraderReviews);
    var response = await http.post(url, body: {'user_id': widget.service.userId});
    var obj = jsonDecode(response.body);
    bool isCorrect = obj[0]['status'] == 'true';
    if (isCorrect) {
      setState(() {
        reviews = obj;
        isLoadingReviews = false;
      });
    }
    else{
      setState(() {
        isLoadingReviews = false;
      });

      Fluttertoast.showToast(msg: "No Reviews Yet");
    }
  }
}
