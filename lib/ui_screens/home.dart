import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:flutter_booking_app/wrapper.dart';
import 'package:provider/provider.dart';
import 'home_widgets/admin_screen.dart';
import 'home_widgets/profile_screen.dart';
import 'home_widgets/search_screen.dart';
import 'home_widgets/tickets_screen.dart';
import 'home_widgets/time_table_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _pageName = 'Otoraty';
  final List<Map<String, Widget>> _childrenAdmin = [
    {'Admin Panel': AdminScreen()},
    {'Time Table': TimeTableScreen()},
    {'My Profile': ProfileScreen()},

  ];

  final List<Map<String, Widget>> _childrenUser = [
    {'Search': SearchScreen()},
    {'Time Table': TimeTableScreen()},
    {'My Profile': ProfileScreen()},
    {'My Tickets': MyTicketScreen()},
  ];

  UserModel user;

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    final List<BottomNavigationBarItem> _bottomNavigationUser = [
      BottomNavigationBarItem(
          icon: Icon(Icons.search), label: _childrenUser[0].keys.first),
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: _childrenUser[1].keys.first),
      BottomNavigationBarItem(
          icon: Icon(Icons.person_pin), label: _childrenUser[2].keys.first),
      BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: _childrenUser[3].keys.first),
    ];

    final List<BottomNavigationBarItem> _bottomNavigationAdmin = [
      BottomNavigationBarItem(
          icon: Icon(Icons.whatshot), label: _childrenAdmin[0].keys.first),
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: _childrenAdmin[1].keys.first),
      BottomNavigationBarItem(
          icon: Icon(Icons.person_pin), label: _childrenAdmin[2].keys.first),

    ];


    if(snapshot!=null){
       user=UserModel.fromJson(snapshot.data());
      Wrapper.UNAME = '${user.firstName} ${user.lastName}';
      if(user!=null && user.type=='admin' && _currentIndex ==0){
        _pageName = 'Admin Panel';
        setState(() {

        });
      }else if(user!=null && user.type=='user'&& _currentIndex ==0){
        _pageName = 'Search';
        setState(() {

        });
      }
    }

    return Scaffold(
        appBar: new AppBar(
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: Uti().pinkColor,
            title: Text(
              _pageName,
              style: TextStyle(
                  color: Uti().mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.getWidth(5)),
            )),
        body: snapshot !=null ?Container(
            width: Dimensions.getWidth(100),
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
            child: user!=null && user.type=='admin' ?_childrenAdmin[_currentIndex].values.first :_childrenUser[_currentIndex].values.first

        )

            :SizedBox(),
        bottomNavigationBar:  BottomNavigationBar(
            items: user!=null && user.type=='admin' ?_bottomNavigationAdmin:_bottomNavigationUser,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageName = user!=null && user.type=='admin' ? _childrenAdmin[index].keys.first : _childrenUser[index].keys.first;
              });
            },
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            elevation: 0.0,
            selectedItemColor: Uti().white,
            backgroundColor: Uti().accentColor,
          ),
        );
  }
}
