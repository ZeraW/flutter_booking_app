import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
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
  String _pageName = 'Search';
  final List<Map<String, Widget>> _children = [
    {'Search': SearchScreen()},
    {'Time Table': TimeTableScreen()},
    {'My Profile': ProfileScreen()},
    {'My Tickets': MyTicketScreen()},
  ];



  @override
  Widget build(BuildContext context) {
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);

    UserModel user = snapshot != null ? new UserModel.fromJson(snapshot.data()) : null;

    final List<BottomNavigationBarItem> _bottomNavigation = [
      BottomNavigationBarItem(
          icon: Icon(Icons.search), label: _children[0].keys.first),
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: _children[1].keys.first),
      BottomNavigationBarItem(
          icon: Icon(Icons.person_pin), label: _children[2].keys.first),
      BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: _children[3].keys.first),
    ];

    if(user!=null && user.type=='admin'){
      _children.add({'Admin Panel': AdminScreen()});
      _bottomNavigation.add(BottomNavigationBarItem(
          icon: Icon(Icons.whatshot), label: _children[4].keys.first));
    }

    return snapshot!=null ?Scaffold(
        appBar: new AppBar(
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: MyColors().pinkColor,
            title: Text(
              _pageName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.getWidth(5)),
            )),
        body: Container(
            width: Dimensions.getHeight(100),
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
            child: _children[_currentIndex].values.first),
        bottomNavigationBar:  BottomNavigationBar(
            items: _bottomNavigation,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageName = _children[index].keys.first;
              });
            },
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            elevation: 0.0,
            selectedItemColor: MyColors().white,
            backgroundColor: MyColors().accentColor,
          ),
        ):SizedBox();
  }
}

/*class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title='home'}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Ticket> ticketList;

  void _addNewTicket() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => AddNewTicket(getTicketList)));
  }

  @override
  void initState() {
    super.initState();
    getTicketList();
  }

  void getTicketList() async {
    ticketList = await SharedPref().getTickets();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.callAtBuild(context: context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            ticketList != null
                ? Table(
                    defaultColumnWidth: FlexColumnWidth(1.0),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(),
                    children: ticketList
                        .map((item) => TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${item.name}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: item.id == 0
                                          ? FontWeight.w600
                                          : FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${item.from}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: item.id == 0
                                          ? FontWeight.w600
                                          : FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${item.to}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: item.id == 0
                                          ? FontWeight.w600
                                          : FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: item.id == 0
                                    ? Center(
                                      child: Text(
                                          'Action',
                                          style: TextStyle(
                                              fontWeight: item.id == 0
                                                  ? FontWeight.w600
                                                  : FontWeight.w400),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    )
                                    : GestureDetector(
                                        onTap: () async {
                                          ticketList.removeWhere((element) =>
                                              element.id == item.id);
                                          await SharedPref()
                                              .saveTicket(list: ticketList);

                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ),
                                      ),
                              ),
                            ]))
                        .toList()
                        .cast<TableRow>(),
                  )
                : Text(''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTicket,
        tooltip: 'addTicket',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
