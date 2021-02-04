import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/server/auth.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/wrapper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: Dimensions.getHeight(2)),
          height: Dimensions.getHeight(7.0),
          width: Dimensions.getWidth(65),
          child: RaisedButton(
            onPressed: () async{
              await AuthService().signOut();
            },
            color: Color(0xffE43141),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
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
    );
  }
}
