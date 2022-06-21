import 'package:customer_can_do/models/current_user.dart';
import 'package:customer_can_do/screens/login_screen.dart';
import 'package:customer_can_do/screens/splash_screen.dart';
import 'package:customer_can_do/screens/tabs/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'models/user.dart';
import 'network/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? userData;
  @override
  void initState() {
    getData();
    getLocation();
    initOneSignal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Can Do Today',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        // home: TestPage(),
        // routes: {
        //   '/newtest': (ctx) => NewTestPage(),
        // },
        home: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 3)),
          builder: (c, s) => s.connectionState != ConnectionState.done
              ? SplashScreen()
              : userData == null
                  ? LoginScreen()
                  : TabsPage(),
        ) // userData == null ? LoginScreen() : TabsPage(),
        );
  }

  void getData() async {
    var user = await Constants().getUserData();
    if (user != null) {
      Constants().saveUserInCahe(user);
      setState(() async {
        userData = user;
         initOneSignal();

      });
    } else {
      setState(() {
        userData = null;
      });
    }
  }

  void getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    String loc = "${_locationData.latitude},${_locationData.longitude}";
    CurrentUser.location = loc;
    Constants().getAddress(_locationData);
    CurrentUser.lat = _locationData.latitude!;
    CurrentUser.lng = _locationData.longitude!;

    Constants()
        .saveLatLng("${_locationData.latitude}", "${_locationData.longitude}");
  }

  void initOneSignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(Constants.oneSignalId);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });



  }

}
