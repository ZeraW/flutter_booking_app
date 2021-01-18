import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/ui_screens/login.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';

class ChooseLoginType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Dimensions.getWidth(14),
                ),
                Center(
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.getWidth(15)),
                        child: Container(
                          height: Dimensions.getHeight(25),
                          width: Dimensions.getWidth(90),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(Dimensions.getWidth(5)),
                          child: Image.asset(
                            'assets/images/otoraty.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ))),
                Spacer(),
                Container(
                  //rounded corner + color
                  decoration: BoxDecoration(
                      color: MyColors().btnColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(Dimensions.getWidth(7))),
                  //margin
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(4)),
                  //height
                  height: Dimensions.getHeight(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Continue as:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: Dimensions.getWidth(7)),
                      ),
                      Divider(
                        color: Colors.white,
                        indent: 40,
                        endIndent: 40,
                      ),
                      // on touch
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => LoginScreen()));
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Client',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: Dimensions.getWidth(6)),
                              ),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.getWidth(10)),
                                child: Container(
                                  height: Dimensions.getWidth(20),
                                  width: Dimensions.getWidth(20),
                                  color: MyColors().accentColor,
                                  child: Image.asset(
                                    'assets/images/user.jpeg',
                                    fit: BoxFit.fitHeight,
                                    height: Dimensions.getWidth(60),
                                    width: Dimensions.getWidth(95),
                                  ), // replace
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        indent: 40,
                        endIndent: 40,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => LoginScreen()));
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Admin',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: Dimensions.getWidth(6)),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.getWidth(10)),
                                  child: Container(
                                    height: Dimensions.getWidth(20),
                                    width: Dimensions.getWidth(20),
                                    color: MyColors().accentColor,
                                    child: Image.asset(
                                      'assets/images/admin.jpeg',
                                      fit: BoxFit.fitHeight,
                                      height: Dimensions.getWidth(60),
                                      width: Dimensions.getWidth(95),
                                    ), // replace
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimensions.getWidth(4),
                )
              ],
            ),
          )),
    );
  }
}
