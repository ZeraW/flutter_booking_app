import 'package:flutter/material.dart';

class MyColors {
  Color mainColor = Color(0xff373951);
  Color pinkColor = Color(0xffF4DEFD);
  Color accentColor = Color(0xff0F2F44);

  Color greenColor = Color(0xff84ae1a);
  Color btnColor = Color(0xff373951);

  Color offWhite = Color(0xffF1F1F1);
  Color textColor = Color(0xff373951);
  Color backGroundColor = Color(0xffd8dbff);
  Color black = Colors.black;
  Color white = Colors.white;

}

class EnStrings {
  String appName = "BookingApp";
}

class MyTheme {
  ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(

        textTheme: TextTheme(headline6: TextStyle(
            fontWeight: FontWeight.w200,
            color: MyColors().mainColor,),
          headline1: TextStyle(
              fontWeight: FontWeight.w200,
              color: MyColors().mainColor,),
          headline2: TextStyle(
              fontWeight: FontWeight.w200,
              color: MyColors().mainColor,),
          headline3: TextStyle(
              fontWeight: FontWeight.w200,
              color: MyColors().mainColor,),
          headline4: TextStyle(
              fontWeight: FontWeight.w200,
              color: MyColors().mainColor,),
          headline5: TextStyle(
              fontWeight: FontWeight.w200,
              color: MyColors().mainColor,),
          bodyText1: TextStyle(
              fontWeight: FontWeight.w200,
              color: MyColors().textColor,),
          bodyText2: TextStyle(
              fontWeight: FontWeight.w200,
              color: MyColors().textColor,
          ),
          button: TextStyle(
              fontWeight: FontWeight.w200,
              color:Colors.white,
          ),
          subtitle1: TextStyle(
              fontWeight: FontWeight.w200,
              color: MyColors().textColor,
          ),
          subtitle2: TextStyle(
              fontWeight: FontWeight.w200,
              color: MyColors().textColor,
          ),

        ),
        primaryColor: MyColors().mainColor,
        accentColor: MyColors().accentColor,
        scaffoldBackgroundColor: MyColors().white,
        cardColor: Colors.white,
        textSelectionColor: Colors.amberAccent,
        errorColor: MyColors().greenColor,
        textSelectionHandleColor: Colors.grey,
        appBarTheme: _appBarTheme());
  }

  AppBarTheme _appBarTheme() {
    return AppBarTheme(
      elevation: 0.0,
      textTheme: TextTheme(
          headline6: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: MyColors().textColor,)),
      color: MyColors().mainColor,
      iconTheme: IconThemeData(
        color: MyColors().textColor,
      ),
    );
  }
}
