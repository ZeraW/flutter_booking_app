import 'package:flutter/material.dart';
import 'package:flutter_booking_app/server/auth_manage.dart';
import 'package:flutter_booking_app/ui_screens/login.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AuthManage>(builder: (context, auth, child) {
        return WillPopScope(
            onWillPop: () async {
              // You can do some work here.
              // Returning true allows the pop to happen, returning false prevents it.
              auth.onBackPressed();
              return false;
            }, child: auth.currentWidget());
      }),
    );
  }
}

class ChooseLoginType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Uti().pinkColor,
            Uti().accentColor,
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
            height: Dimensions.getHeight(6),
          ),
          Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.getWidth(15)),
                  child: Container(
                    height: Dimensions.getHeight(20),
                    width: Dimensions.getWidth(80),
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
                color: Uti().btnColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(Dimensions.getWidth(7))),
            //margin
            margin: EdgeInsets.symmetric(horizontal: Dimensions.isPortrait() ?Dimensions.getWidth(4):Dimensions.getWidth(80)),
            //height

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
                    Provider.of<AuthManage>(context, listen: false)
                        .toggleWidgets(currentPage: 1, type: "user");
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
                            color: Uti().accentColor,
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
                      Provider.of<AuthManage>(context, listen: false)
                          .toggleWidgets(currentPage: 1, type: "admin");
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
                            borderRadius:
                                BorderRadius.circular(Dimensions.getWidth(10)),
                            child: Container(
                              height: Dimensions.getWidth(20),
                              width: Dimensions.getWidth(20),
                              color: Uti().accentColor,
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
    ));
  }
}
