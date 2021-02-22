import 'package:flutter/material.dart';

class Uti {
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

  static MaterialStateProperty<Color> materialColor(var color){
    return MaterialStateProperty.all<Color>(color);
  }
  static MaterialStateProperty<OutlinedBorder>  materialShape(var shape){
    return MaterialStateProperty.all<OutlinedBorder>(shape);
  }

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
            color: Uti().mainColor,),
          headline1: TextStyle(
              fontWeight: FontWeight.w200,
              color: Uti().mainColor,),
          headline2: TextStyle(
              fontWeight: FontWeight.w200,
              color: Uti().mainColor,),
          headline3: TextStyle(
              fontWeight: FontWeight.w200,
              color: Uti().mainColor,),
          headline4: TextStyle(
              fontWeight: FontWeight.w200,
              color: Uti().mainColor,),
          headline5: TextStyle(
              fontWeight: FontWeight.w200,
              color: Uti().mainColor,),
          bodyText1: TextStyle(
              fontWeight: FontWeight.w200,
              color: Uti().textColor,),
          bodyText2: TextStyle(
              fontWeight: FontWeight.w200,
              color: Uti().textColor,
          ),
          button: TextStyle(
              fontWeight: FontWeight.w200,
              color:Colors.white,
          ),
          subtitle1: TextStyle(
              fontWeight: FontWeight.w200,
              color: Uti().textColor,
          ),
          subtitle2: TextStyle(
              fontWeight: FontWeight.w200,
              color: Uti().textColor,
          ),

        ),
        primaryColor: Uti().mainColor,
        accentColor: Uti().accentColor,
        scaffoldBackgroundColor: Uti().white,
        cardColor: Colors.white,
        textSelectionColor: Colors.amberAccent,
        errorColor: Uti().greenColor,
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
              color: Uti().textColor,)),
      color: Uti().mainColor,
      iconTheme: IconThemeData(
        color: Uti().textColor,
      ),
    );
  }
}
