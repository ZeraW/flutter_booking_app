import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _repasswordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  int _selectedCity;

  String _phoneError = "";
  String _countryError = "";
  String _nameError = "";
  String _lastNameError = "";
  String _apiError = "";
  String _passError = "";
  String _rePassError = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  _initData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.chevron_left,
              color: MyColors().mainColor,
              size: Dimensions.getWidth(8.0),
            ),
          ),
          backgroundColor: MyColors().pinkColor,
          title: Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.black54, fontSize: Dimensions.getWidth(4.5)),
          )),
      body: Container(
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
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.getHeight(2),
            horizontal: Dimensions.getWidth(4)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            ///TODO fix bug key Appear
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.getWidth(13)),
                  child: Container(
                    height: Dimensions.getWidth(26),
                    width: Dimensions.getWidth(26),
                    color: Colors.grey,
                    child: CachedNetworkImage(
                      imageUrl: "imageUrl",
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          )/*CircularProgressIndicator()*/,
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.white,
                      ),
                    ), // replace
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.getHeight(3.5),
              ),
              TextFormBuilder(
                hint: "First Name",
                controller: _nameController,
              ),
              getErrorWidget(context,
                  isValid: _nameError != "", errorText: _nameError),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Last Name",
                controller: _lastNameController,
              ),
              getErrorWidget(context,
                  isValid: _lastNameError != "", errorText: _lastNameError),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Phone Number",
                keyType: TextInputType.number,
                controller: _phoneController,
              ),
              getErrorWidget(context,
                  isValid: _phoneError != "", errorText: _phoneError),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Password",
                isPassword: true,
                controller: _passwordController,
              ),
              getErrorWidget(context,
                  isValid: _passError != "", errorText: _passError),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Confirm Password",
                isPassword: true,
                controller: _repasswordController,
              ),
              getErrorWidget(context,
                  isValid: _rePassError != "", errorText: _rePassError),
              getErrorWidget(context,
                  isValid: _apiError != "", errorText: _apiError),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              SizedBox(
                height: Dimensions.getHeight(7.0),
                child: RaisedButton(
                  onPressed: () {
                    _reg(context);
                  },
                  color: MyColors().mainColor,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.getWidth(4.0),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  _reg(BuildContext context) async {}
}

Widget getErrorWidget(BuildContext context,
    {@required bool isValid, @required String errorText}) {
  return Visibility(
    visible: isValid,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.only(top: 5),
      alignment: Alignment.center,
      child: Text(
        '$errorText',
        textScaleFactor: 1.0,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ),
  );
}

