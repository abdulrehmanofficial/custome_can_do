import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:customer_can_do/models/category.dart';
import 'package:customer_can_do/models/current_user.dart';
import 'package:customer_can_do/models/service.dart';
import 'package:customer_can_do/network/api_request.dart';
import 'package:customer_can_do/network/constant.dart';
import 'package:customer_can_do/screens/trader_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class HomePage extends StatefulWidget {
  String catId;
  HomePage(this.catId);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<HomePage> {
  // String _email, _password;
  List<Service> services = [];
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Future<User> _futureUser;
  bool _showItem = false;
  Service? selectedService;
  String dropdownValue = "Plumber";
  List<String> menus = ['Plumber', 'Electration', 'Painter', 'Mechanic'];

  bool isLoading = false;

  final List<Marker> _markers = <Marker>[];
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(CurrentUser.lat, CurrentUser.lng),
    zoom: 12.4746,
  );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 12.151926040649414);

  @override
  void initState() {
    // TODO: implement initState
    //_addMarker(37.43296265331129, -122.08832357078792);
    super.initState();
    // _addCurrMarker(LatLng(CurrentUser.lat, CurrentUser.lng), "current");
    isLoading = true;
    getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Nearby Services"),
          //leading: const Text(""),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      markers: Set<Marker>.of(_markers),
                      myLocationEnabled: true,
                      // myLocationButtonEnabled: true,
                      onTap: (la) {
                        print(la);
                        setState(() {
                          _showItem = false;
                        });
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 200,
                      // color: Colors.red,
                      child: _showItem
                          ? _item(context, selectedService!)
                          : Text(""),
                    ),
                  ),
                  isLoading
                      ? Container(
                          child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      : Container(),
                ],
              ),
            )
          ],
        ));
  }

  void mapPinTapped() {
    print("tapped");
  }

  Future<void> _addMarker(LatLng latlng, Service service, String icon) async {
    var markerIdVal = service.serviceId.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    final Uint8List markerIcon =
        await Constants().getBytesFromAsset('assets/images/$icon.png', 150);

    // creating a new MARKER
    final Marker marker = Marker(
      icon: BitmapDescriptor.fromBytes(markerIcon),
      markerId: markerId,
      position: latlng,
      infoWindow: InfoWindow(
        title: service.categoryName,
        snippet: "",
      ),
      onTap: () {
        print("tapped");
        setState(() {
          _showItem = !_showItem;
          selectedService = service;
        });
      },
    );

    setState(() {
      //   // adding a new marker to map
      _markers.add(marker);
    });
  }

  Future<void> _addCurrMarker(LatLng latlng, String icon) async {
    var markerIdVal = "adsad".toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    final Uint8List markerIcon =
        await Constants().getBytesFromAsset('assets/images/curr.png', 80);

    // creating a new MARKER
    final Marker marker = Marker(
      icon: BitmapDescriptor.fromBytes(markerIcon),
      markerId: markerId,
      position: latlng,
      infoWindow: InfoWindow(
        title: "You current Location",
        snippet: "",
      ),
    );
    _markers.add(marker);
  }

  Widget _item(BuildContext context, Service service) {
    return Container(
      // width: MediaQuery.of(context).size.width - 50,
      margin: EdgeInsets.all(10),
      height: 160,
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
                  child: Image.asset("assets/images/aclogo.png"),
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
                              service.firstName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Container(
                                child: TextButton(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                ),
                                child: Text("\$ ${service.startingPrice}/hr"),
                              ), //Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _showItem = !_showItem;
                                });
                              },
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(service.categoryName), Text("")],
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
            Container(
              margin: EdgeInsets.only(right: 40),
              child: Row(
                children: [
                  // Container(
                  //   height: 20,
                  //   width: 20,
                  //   child: Icon(Icons.money),
                  //   //color: Theme.of(context).primaryColor,
                  //   decoration: BoxDecoration(
                  //     // color: Theme.of(context).primaryColor,
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  // Text(
                  //     selectedService != null
                  //         ? "\$ ${service.startingPrice}/hr"
                  //         : "",
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 16,
                  //         color: Colors.grey)
                  //         ),
                ],
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
                        TextButton(
                          onPressed: () async {
                            bool? res =
                                await FlutterPhoneDirectCaller.callNumber(
                                    service.mobile);
                          },
                          child: Text(service.mobile,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 80,
                    color: Colors.green,
                    child: TextButton(
                      child: Text(
                        "Details",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        //api call
                        //createOrder();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new TraderDetailPage(selectedService!)));
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // update map camera
  Future<void> moveCamera(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 14)));

  }

  LatLng getLatLng(String latlng) {
    var arr = latlng.split(",");
    String latstr = arr[0];
    String lngstr = arr[1];

    double lat = double.parse(latstr);
    double lng = double.parse(lngstr);

    return LatLng(lat, lng);
  }

  /// api call

  void getServices() {
    ApiRequest().getMySeriveCall(widget.catId).then((reg) {
      if (reg != null) {
        services = reg;
        // Constants().showalert("${services.length} service available");
        services.forEach((element) {
          String latlng = element.latlong;

          var newlatlng = getLatLng(latlng);
          if (element.onlineStatus == "1") {
            _addMarker(newlatlng, element, "pin_green");
          }
          // else {
          //   _addMarker(newlatlng, element, "pin_orange");
          // }
        });
      }
      setState(() {
        moveCamera(LatLng(CurrentUser.lat, CurrentUser.lng));
        isLoading = false;
      });
    });
  }

  void createOrder() {
    if (selectedService != null) {
      String currUserId = CurrentUser.id ?? "";
      String loca = CurrentUser.location ?? "";
      String address = CurrentUser.address ?? "";
      ApiRequest()
          .createOderCall(
              selectedService!.userId,
              currUserId,
              selectedService!.categoryId,
              selectedService!.startingPrice,
              loca,
              address)
          .then((reg) {
        if (reg != null) {
          Constants().showalert(reg.message);
        }
      });
    }
  }
}
