import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/auth.dart';
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
  TextEditingController _phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);

    if (snapshot != null) {
      user = UserModel.fromJson(snapshot.data());
      _nameController.text = user.firstName + " " + user.lastName;
      _phoneController.text = user.phone;
    }

    return user != null
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(10)),
            child: Column(
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
                                  CircularProgressIndicator(),
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
                  hint: "First Name",
                  enabled: false,
                  controller: _nameController,
                ),
                SizedBox(
                  height: Dimensions.getHeight(3.0),
                ),
                TextFormBuilder(
                  hint: "Phone Number",
                  keyType: TextInputType.number,
                  enabled: false,
                  controller: _phoneController,
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
}
