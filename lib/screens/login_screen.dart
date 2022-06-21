import 'package:customer_can_do/network/api_request.dart';
import 'package:customer_can_do/screens/forgot_page.dart';
import 'package:customer_can_do/screens/registrantion_screen.dart';
import 'package:customer_can_do/screens/search_page.dart';
import 'package:customer_can_do/screens/tabs/pages/tabs_page.dart';
import 'package:customer_can_do/screens/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:customer_can_do/network/api_request.dart';
import 'package:customer_can_do/network/constant.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // String _email, _password;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Future<User> _futureUser;
  bool isLoading = false;
  String loginType = "";
  String _email = "";
  String _password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(""),
        leading: const Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
          child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  "assets/images/aclogo.png",
                ),
              ),
              // _actionSheet(context),
              _form(context),
              _signUp(context),
              _forgetPass(context),
            ],
          ),
        ],
      )),
    );
  }

  /// Form

  Widget _form(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            padding: const EdgeInsetsDirectional.only(top: 10),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an email';
                }
                if (!input.isValidEmail()) {
                  return 'Email format is not correct';
                }
              },
              onSaved: (input) => _email = input!,
              onEditingComplete: () {},
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an password';
                }
              },
              onSaved: (input) => _password = input!,
              decoration: const InputDecoration(labelText: "Password "),
              obscureText: true,
            ),
          ),
          isLoading == false
              ? Container(
                  width: 200,
                  height: 40,
                  margin: const EdgeInsetsDirectional.only(top: 30),
                  child: RaisedButton(
                    onPressed: () {
                      final _formState = _globalKey.currentState;

                      if (_formState!.validate()) {
                        _formState.save();
                        setState(() {
                          isLoading = true;
                        });
                        apiCall();
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    child: const Text(
                      "Signin",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : const CircularProgressIndicator()
        ],
      ),
    );
  }

  /// signup

  Widget _signUp(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 0),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Don't have acount?"),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RegistrationScreen()));
              },
              child: const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///

  // forgot password

  Widget _forgetPass(BuildContext context) {
    return Container(
      height: 70,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ForgotPage()));
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void apiCall() {
    if (_email != "" && _password != "") {
      ApiRequest().signInCall(_email, _password).then((user) {
        if (user!.status == "true") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TabsPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          Constants().showalert(user.message ?? "Invalid email or password");
        }
        setState(() {
          isLoading = false;
        });
      }).catchError((onError){
        Constants().showalert(onError.toString());
      });
      setState(() {
        isLoading = false;
      });
    }
  }
}
