import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/auth.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel user;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nationalIdController = new TextEditingController();
  bool isEnabled = false;
  String _phoneError = "";
  String _nameError = "";
  String _emailError = "";
  String _nationalIdError = "", _pwError = "";

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);

    if (snapshot != null) {
      user = UserModel.fromJson(snapshot.data());
      _nameController.text = user.firstName + " " + user.lastName;
      _phoneController.text = user.phone;
      _emailController.text = user.mail;
      _nationalIdController.text = user.nationalId;
      _passwordController.text = user.password;
    }

    return user != null
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(10)),
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getWidth(13)),
                    child: Container(
                      height: Dimensions.getWidth(26),
                      width: Dimensions.getWidth(26),
                      child: user.logo != null
                          ? CachedNetworkImage(
                              imageUrl: user.logo,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error))
                          : Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.white,
                            ), // replace
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.getHeight(3.5),
                ),
                TextFormBuilder(
                  hint: "Name",
                  enabled: isEnabled,
                  controller: _nameController,
                ),
                SizedBox(
                  height: Dimensions.getHeight(3.0),
                ),
                TextFormBuilder(
                  hint: "Email",
                  enabled: false,
                  controller: _emailController,
                ),
                SizedBox(
                  height: Dimensions.getHeight(3.0),
                ),
                TextFormBuilder(
                  hint: "Phone Number",
                  keyType: TextInputType.number,
                  enabled: isEnabled,
                  controller: _phoneController,
                ),
                SizedBox(
                  height: Dimensions.getHeight(3.0),
                ),
                TextFormBuilder(
                  hint: "National ID",
                  enabled: false,
                  controller: _nationalIdController,
                ),
                SizedBox(
                  height: Dimensions.getHeight(3.0),
                ),
                TextFormBuilder(
                  hint: "Password",
                  keyType: TextInputType.text,
                  isPassword: true,
                  enabled: isEnabled,
                  controller: _passwordController,
                  errorText: _pwError,
                ),
                SizedBox(
                  height: Dimensions.getHeight(3.0),
                ),
                Container(
                  margin: EdgeInsets.only(top: Dimensions.getHeight(2)),
                  height: Dimensions.getHeight(7.0),
                  width: Dimensions.getWidth(65),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isEnabled == true) {
                        _editProfile();
                        setState(() {
                          isEnabled = false;
                        });
                      } else {
                        isEnabled = true;
                      }
                      setState(() {});
                    },
                    style: ButtonStyle(
                        backgroundColor: Uti.materialColor(Colors.green),
                        shape: Uti.materialShape(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
                    child: Text(
                      !isEnabled ? "Edit" : 'Save Changes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.getWidth(4.0),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: Dimensions.getHeight(2)),
                  height: Dimensions.getHeight(7.0),
                  width: Dimensions.getWidth(65),
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService().signOut();
                    },
                    style: ButtonStyle(
                        backgroundColor: Uti.materialColor(Color(0xffc13001)),
                        shape: Uti.materialShape(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
                    child: Text(
                      "SignOut",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.getWidth(4.0),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Text('Loading User ...');
  }

  _editProfile() async {
    print('here');
    String firstName = _nameController.text;
    String mail = _emailController.text;
    String nationalId =
        _nationalIdController.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String phone =
        _phoneController.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String password = _passwordController.text;

    if (firstName == null || firstName.isEmpty) {
      _nameError = "Please enter first name";
      setState(() {});
    } else if (mail == null || mail.isEmpty) {
      clear();
      _emailError = "Please enter email Address";
      setState(() {});
    } else if (!isEmail(mail)) {
      clear();
      _emailError = "Please enter Correct email Address";
      setState(() {});
    } else if (phone == null || phone.isEmpty) {
      clear();
      _phoneError = "Please enter a valid phone number";
    } else if (nationalId == null || nationalId.isEmpty) {
      clear();
      _nationalIdError = "Please enter National ID";
    } else if (password == null || password.isEmpty || password.length < 5) {
      clear();
      _pwError = "Please enter Valid Password";
      setState(() {});
    } else {
      print('there');
      clear();
      UserModel newUser = UserModel(
          id: user.id,
          firstName: firstName,
          lastName: '',
          password: password,
          mail: user.mail,
          nationalId: nationalId,
          phone: phone,
          logo: user.logo,
          type: user.type);

      AuthService().changePassword(password == user.password ? null : password,
          () async {
        await DatabaseService().updateUserData(user: newUser);
      });
    }
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  void clear() {
    setState(() {
      _phoneError = "";
      _nameError = "";
      _pwError = "";
    });
  }
}
