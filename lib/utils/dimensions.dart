import 'package:flutter/material.dart';


class Dimensions {
  static double _width;
  static double _height;
  static Orientation _orientation;

  static callAtBuild({@required BuildContext context}){
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    _orientation = MediaQuery.of(context).orientation;
  }
  static _getDesirableWidthX(double percent) {
    return _width * (percent / 100);
  }

  static _getDesirableHeightX(double percent) {
    return _height * (percent / 100);
  }

  static getWidth(double percent) {
    return _orientation == Orientation.portrait
        ? _width * (percent / 100)
        : _getDesirableHeightX(percent);
  }

  static getHeight(double percent) {
    return _orientation == Orientation.portrait
        ? _height * (percent / 100)
        : _getDesirableWidthX(percent);
  }
}
