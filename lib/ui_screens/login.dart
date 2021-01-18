import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_booking_app/ui_screens/register.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String _emailError = "";
  String _apiError = "";
  String _passwordError = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: SingleChildScrollView(
          child: Container(
            height: Dimensions.getHeight(100),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      MyColors().pinkColor,
                      MyColors().accentColor,
                    ],
                    stops: [0.1, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(4.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: Dimensions.getHeight(10),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.getWidth(20.0)),
                    child: Image.asset(
                      "assets/images/otoraty.jpeg",
                      fit: BoxFit.cover,
                      height: Dimensions.getWidth(40.0),
                      width: Dimensions.getWidth(40.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.getHeight(7.0),
                ),
                TextFormBuilder(
                  controller: _emailController,
                  hint: "Phone Number :",
                  keyType: TextInputType.phone,
                ),
                if (_emailError != "") ...[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.only(top: 5),
                    alignment: Alignment.center,
                    child: Text(
                      '$_emailError',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14 / MediaQuery.of(context).textScaleFactor,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
                SizedBox(
                  height: Dimensions.getHeight(3.0),
                ),
                TextFormBuilder(
                  controller: _passwordController,
                  hint: "Password :",
                  keyType: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                if (_passwordError != "") ...[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.only(top: 5),
                    alignment: Alignment.center,
                    child: Text(
                      '$_passwordError',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14 / MediaQuery.of(context).textScaleFactor,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
                SizedBox(
                  height: Dimensions.getHeight(4.0),
                ),
                SizedBox(
                  height: Dimensions.getHeight(7.0),
                  child: RaisedButton(
                    onPressed: () {
                      _login(context);
                    },
                    color: Color(0xff373951),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.getWidth(4.0),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                //Spacer(),
                SizedBox(
                  height: Dimensions.getHeight(4.0),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RegisterScreen()));
                  },
                  child: Center(
                    child: Text(
                      "Create new account",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: Dimensions.getWidth(4.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.getHeight(4.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => HomeScreen()));
  }
}

class TextFormBuilder extends StatelessWidget {
  final String hint;
  final TextInputType keyType;
  final bool isPassword;
  final TextEditingController controller;

  TextFormBuilder({this.hint, this.keyType, this.isPassword, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        // maxLength: maxLength,
        controller: controller,
        validator: (value) {
          if (value.isEmpty) {
            return "الرجاء إدخال نص";
          }
          return null;
        },
        enabled: true,
        //controller: _controller,
        maxLines: 1,

        //onChanged: onChange,
        keyboardType: keyType != null ? keyType : TextInputType.text,
        obscureText: isPassword != null ? isPassword : false,
        decoration: InputDecoration(
          hintText: "$hint",
          hintStyle:
              TextStyle(color: Colors.white, fontSize: Dimensions.getWidth(4.5)),
          contentPadding: new EdgeInsets.symmetric(
              vertical: Dimensions.getHeight(1.0),
              horizontal: Dimensions.getWidth(4.0)),
          focusedErrorBorder: new OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
          errorStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w500),
          focusedBorder: new OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
          errorBorder: new OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Theme.of(context).accentColor),
          ),
          enabledBorder: new OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: Colors.black54, style: BorderStyle.solid),
          ),
          fillColor: Colors.white,
        ));
  }
}

