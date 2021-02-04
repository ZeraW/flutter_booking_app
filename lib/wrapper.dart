import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/server/auth_manage.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_screens/choose_login_type.dart';
import 'package:provider/provider.dart';
import 'ui_screens/home.dart';

class Wrapper extends StatefulWidget {
  static String UID = '';
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either the Home or Authenticate widget
    if (user == null) {
      return ChangeNotifierProvider(
          create: (context) => AuthManage(), child: RootScreen());
    } else {
      Wrapper.UID = user.uid;
      return StreamProvider<DocumentSnapshot>.value(
          value: DatabaseService().getUserById,
          child: HomeScreen());
    }
  }
}



