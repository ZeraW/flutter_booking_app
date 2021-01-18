import 'package:flutter/material.dart';
import 'package:flutter_booking_app/ui_screens/choose_login_type.dart';
import 'package:flutter_booking_app/ui_screens/login.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double x = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bangBang();
  }

  void bangBang() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        /*setState(() {
          x = 1;
        });*/
      }
    }).then((value) {
      Future.delayed(Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ChooseLoginType()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.callAtBuild(context: context);

    return Scaffold(
      body: Container(
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
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.getWidth(25.0)),
            child: Image.asset(
              "assets/images/otoraty.jpeg",
              fit: BoxFit.cover,
              height: Dimensions.getWidth(50.0),
              width: Dimensions.getWidth(50.0),
            ),
          )/*AnimatedOpacity(
            opacity: x,
            duration: Duration(milliseconds: 1000),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.getWidth(25.0)),
              child: Image.asset(
                "assets/images/otoraty.jpeg",
                fit: BoxFit.cover,
                height: Dimensions.getWidth(50.0),
                width: Dimensions.getWidth(50.0),
              ),
            ),
          )*/,
        ),
      ),
    );
  }
}


