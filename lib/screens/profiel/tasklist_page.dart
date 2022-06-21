import 'package:customer_can_do/models/current_user.dart';
import 'package:customer_can_do/models/orders.dart';
import 'package:customer_can_do/network/api_request.dart';
import 'package:customer_can_do/network/constant.dart';
import 'package:customer_can_do/network/constant.dart';
import 'package:customer_can_do/screens/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_launcher/maps_launcher.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List<Orders> completeOrders = [];
  List<Orders> inProgressOrders = [];
  List<Orders> pendingOrders = [];
  List<Orders> orders = [];

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _reviewFieldController = TextEditingController();
  
  bool isLoading = false;
  double user_rating = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
    getPendingOrders();
    getCompleteOrders();
    getinProgresOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "PENDING",
                ),
                Tab(
                  text: "IN-PROGRESS",
                ),
                Tab(
                  text: "COMPLETED",
                ),
              ],
              // onTap: (),
            ),
            title: const Text('My Tasks'),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  _completeView(context, pendingOrders, 0),
                  _completeView(context, inProgressOrders, 1),
                  _completeView(context, completeOrders, 2),
                  // Icon(Icons.directions_bike),
                ],
              ),
              isLoading
                  ? Container(
                      child: Center(
                      child: CircularProgressIndicator(),
                    ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _completeView(BuildContext context, List<Orders> _orders, int type) {
    return RefreshIndicator(
      onRefresh: () async {
        _pullRefresh(type);
      },
      child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(context, _orders, index, type);
          }),
    );
  }

  Widget _item(
      BuildContext context, List<Orders> _orders, int index, int type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    OrderDetailPage(_orders[index])));
      },
      child: Container(
        // width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.all(10),
        //height: 220,
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
          margin: EdgeInsets.only(left: 20, right: 10),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    // margin: EdgeInsets.only(left: 20),
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(_orders[index].image)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    //color: Colors.red,
                    width: MediaQuery.of(context).size.width - 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _orders[index].firstName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text("\$${_orders[index].price}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_orders[index].categoryName),
                              IconButton(
                                  onPressed: () {
                                    var loc = _orders[index]
                                        .customerLocation
                                        .split(",");
                                    double lat = double.parse(loc[0]);
                                    double lng = double.parse(loc[1]);

                                    MapsLauncher.launchCoordinates(lat, lng);
                                  },
                                  icon: Icon(Icons.map))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(right: 40),
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,

                      //color: Theme.of(context).primaryColor,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(_orders[index].customerAddress,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,

                            //color: Theme.of(context).primaryColor,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                              "${Constants().calculateDistance(CurrentUser.location!, _orders[index].customerLocation)} km",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _button(context, type, _orders, index),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(
      BuildContext context, int type, List<Orders> _orders, int index) {
    switch (type) {
      case 0:
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          //color: Theme.of(context).primaryColor,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),

          child: TextButton(
            child: const Text(
              "Pending",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              print("Complete");

              //markCompleteOrder(_orders[index].orderId);
              //_displayTextInputDialog(context, _orders[index].orderId);
            },
          ),
        );

      case 1:
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          //color: Theme.of(context).primaryColor,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),

          child: TextButton(
            child: const Text(
              "Mark Complete",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              print("IN-PROGRESS");

              //markCompleteOrder(_orders[index].orderId);
              _displayTextInputDialog(context, _orders[index].orderId,_orders[index]);
            },
          ),
        );
      case 2:
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          //color: Theme.of(context).primaryColor,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),

          child: TextButton(
            child: const Text(
              "Completed",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print("IN-PROGRESS");

              //markCompleteOrder(_orders[index].orderId);
              // _displayTextInputDialog(context, _orders[index].orderId);
            },
          ),
        );
    }
    return Text("");
  }

  /// pull to refresh

  Future<void> _pullRefresh(int type) async {
    if (type == 0) {
      getPendingOrders();
    } else if (type == 1) {
      getinProgresOrders();
    } else {
      getCompleteOrders();
    }
  }

  /// get complete orders
  void getCompleteOrders() {
    setState(() {
      isLoading = true;
    });
    completeOrders.clear();
    ApiRequest().getOrdersCall(CurrentUser.id!, "3").then((cats) {
      if (cats != null) {
        completeOrders.clear();
        completeOrders = cats;
        setState(() {});
      } else {
       // Constants().showalert("No order found.");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  /// get inprogress orders

  void getinProgresOrders() {
    setState(() {
      isLoading = true;
    });
    inProgressOrders.clear();
    ApiRequest().getOrdersCall(CurrentUser.id!, "1").then((cats) {
      if (cats != null) {
        inProgressOrders.clear();
        inProgressOrders = cats;
        setState(() {});
      } else {
       // Constants().showalert("No order found.");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  /// pending

  void getPendingOrders() {
    setState(() {
      isLoading = true;
    });
    inProgressOrders.clear();
    ApiRequest().getOrdersCall(CurrentUser.id??"0", "0").then((cats) {
      if (cats != null) {
        pendingOrders.clear();
        pendingOrders = cats;
        setState(() {});
      } else {
        //Constants().showalert("No order found.");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  // mark complete

  void markCompleteOrder(String id, String price) {
    setState(() {
      isLoading = true;
    });
    ApiRequest().completeOrderCall(id, price).then((cats) {
      Constants().showalert(cats.message);
      getCompleteOrders();
      getinProgresOrders();
      setState(() {
        isLoading = false;
      });
    });
  }


void sendTraderRating(String trader_id,double stars,String message) {
    setState(() {
      isLoading = true;
    });
    ApiRequest().addReview(CurrentUser.id.toString(),trader_id,stars.toString(),message,'2');
    return;
  }

  // tab listner
  void _setActiveTabIndex() {
    int index = _tabController.index;
    switch (index) {
      case 0:
        setState(() {
          orders = completeOrders;
        });
        break;
      case 1:
        setState(() {
          orders = inProgressOrders;
        });
        break;
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context, String id,Orders _order) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Please enter total payment and review customer'),
          content: Column(children: [
            TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Price"),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(children: [
              Text('Add Your Review',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                child: Text('Review your user from 1 to 5 stars rating'),),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: RatingBar.builder(
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  user_rating = rating;
                });
              },
            ),),
            TextField(
            controller: _reviewFieldController,
            decoration: InputDecoration(hintText: "Enter Review Message"),
          ),
            ],),
          )
          ],),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                print(_textFieldController.text);
                if (_textFieldController.text != "" && _reviewFieldController.text != "" && user_rating != 0) {
                  sendTraderRating(_order.userId,user_rating,_reviewFieldController.text);
                  markCompleteOrder(id, _textFieldController.text);
                  Navigator.pop(context);
                } else {
                  Constants().showalert("Please enter price and review");
                }
              },
            ),
          ],
        );
      },
    );
  }
}
