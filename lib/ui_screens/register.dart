import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/auth.dart';
import 'package:flutter_booking_app/server/auth_manage.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  String type;

  RegisterScreen({this.type});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _repasswordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  String _phoneError = "";
  String _nameError = "";
  String _lastNameError = "";
  String _passError = "";
  String _rePassError = "";

  File _storedImage;

  @override
  Widget build(BuildContext context) {
    Future<void> _takePicture() async {
      final imageFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 80);

      if (imageFile == null) {
        return;
      }
      setState(() {
        _storedImage = File(imageFile.path);
        print('_storedImage');

        print(_storedImage);
      });
    }

    return Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () => Provider.of<AuthManage>(context, listen: false)
                .toggleWidgets(currentPage: 1, type: widget.type),
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
            children: [
              Center(
                child: GestureDetector(
                  onTap: _takePicture,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getWidth(13)),
                    child: Container(
                      height: Dimensions.getWidth(26),
                      width: Dimensions.getWidth(26),
                      color: Colors.grey,
                      child: _storedImage != null
                          ? Image.file(_storedImage)
                          : Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.white,
                            ), // replace
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.getHeight(3.5),
              ),
              TextFormBuilder(
                hint: "First Name",
                controller: _nameController,
                errorText: _nameError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Last Name",
                controller: _lastNameController,
                errorText: _lastNameError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Phone Number",
                keyType: TextInputType.number,
                controller: _phoneController,
                errorText: _phoneError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Password",
                isPassword: true,
                controller: _passwordController,
                errorText: _passError,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Confirm Password",
                isPassword: true,
                controller: _repasswordController,
                errorText: _rePassError,
              ),
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
            ],
          ),
        ),
      ),
    );
  }

  _reg(BuildContext context) async {
    String firstName = _nameController.text;
    String lastName = _lastNameController.text;
    String phone =
        _phoneController.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String password = _passwordController.text;
    String passwordConfirm = _repasswordController.text;

    if (firstName == null || firstName.isEmpty) {
      _nameError = "Please enter first name";
    } else if (lastName == null || lastName.isEmpty) {
      clear();
      _lastNameError = "Please enter last name";
    } else if (phone == null || phone.isEmpty) {
      clear();
      _phoneError = "Please enter a valid phone number";
    } else if (password == null || password.isEmpty) {
      clear();
      _passError = "Please enter password";
    } else if (passwordConfirm == null || passwordConfirm.isEmpty) {
      clear();
      _rePassError = "Please enter Password confirm";
    } else if (password != passwordConfirm) {
      clear();
      _passError = "Passwords don't matach";
      _rePassError = "Passwords don't matach";
    }else if(_storedImage==null){
      Toast.show("Please Add Image", context,
          backgroundColor: Colors.redAccent,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    } else {
      clear();
      UserModel newUser = UserModel(
          firstName: firstName,
          lastName: lastName,
          password: password,
          phone: phone,
          type: widget.type);
      await AuthService().registerWithEmailAndPassword(
          context: context, newUser: newUser, userImage: _storedImage);
    }
  }

  void clear() {
    setState(() {
      _phoneError = "";
      _nameError = "";
      _lastNameError = "";
      _passError = "";
      _rePassError = "";
    });
  }
}
