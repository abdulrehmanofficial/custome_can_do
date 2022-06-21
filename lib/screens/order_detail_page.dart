import 'package:customer_can_do/models/current_user.dart';
import 'package:customer_can_do/models/orders.dart';
import 'package:customer_can_do/network/api_request.dart';
import 'package:customer_can_do/network/constant.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  Orders service;
  OrderDetailPage(this.service);

  @override
  _TraderDetailPageState createState() => _TraderDetailPageState();
}

class _TraderDetailPageState extends State<OrderDetailPage> {
  bool isLoading = false;

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

  Widget _item(BuildContext context, Orders service) {
    return Container(
      // width: MediaQuery.of(context).size.width - 50,
      margin: EdgeInsets.all(10),
      //height: 170,
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
                  height: 70,
                  width: 70,
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
                        margin: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              service.firstName + " " + service.lastName,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(""), Text("")],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(right: 40),
              child: Row(
                children: [],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, bottom: 5),
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
                          child: Icon(Icons.map),
                          //color: Theme.of(context).primaryColor,
                          decoration: BoxDecoration(
                            //color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(service.customerAddress,
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
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(right: 20, bottom: 5),
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
                          child: Icon(Icons.phone),
                          //color: Theme.of(context).primaryColor,
                          decoration: BoxDecoration(
                            //color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(service.mobile,
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
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(right: 20, bottom: 5, top: 20),
              child: Text(
                "Order Id:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(right: 30, bottom: 5, top: 10),
              child: Text(service.orderId
                  // getSubCats(),
                  //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(right: 20, bottom: 5, top: 20),
              child: Text(
                "Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(right: 30, bottom: 5, top: 10),
              child: Text("\$ ${service.price}"
                  // getSubCats(),
                  //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(right: 20, bottom: 5, top: 20),
              child: Text(
                "Email:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(right: 30, bottom: 5, top: 10),
              child: Text(
                service.email,
                //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            // Container(
            //   alignment: Alignment.topLeft,
            //   color: Colors.green,
            //   margin: EdgeInsets.only(right: 30, bottom: 5, top: 10),
            //   child: TextButton(
            //     onPressed: () {
            //       setState(() {
            //         isLoading = true;
            //       });
            //       createOrder();
            //     },
            //     child: Center(
            //         child: isLoading
            //             ? CircularProgressIndicator(
            //                 color: Colors.white,
            //               )
            //             : Text("Hire Now",
            //                 style:
            //                     TextStyle(color: Colors.white, fontSize: 16))),
            //   ),
            // ),
            SizedBox(
              height: 20,
            )
            //_categoryListView(context, service.subcategories)
          ],
        ),
      ),
    );
  }
}
