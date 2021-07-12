import 'dart:collection';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../models/db_model.dart';
import '../../ui_widget/home_widgets/admin_widgets/admin_card.dart';

class ManageReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<NewStatsModel> mList = Provider.of<List<NewStatsModel>>(context);
    if (mList != null)
      mList.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Booking Report',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mList != null
          ? ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.getWidth(2),
                  vertical: Dimensions.getHeight(1.5)),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return ExpansionTile(
                  childrenPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text(
                    'Year: ${mList[index].id}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    TripRepCard(
                      title: 'Financial Report',
                      icon: Icons.monetization_on_outlined,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    FinancialReportScreen(mList[index])));
                      },
                    ),
                    TripRepCard(
                      title: 'Management report',
                      icon: Icons.article_outlined,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MultiProvider(
                                        providers: [
                                          StreamProvider<List<CityModel>>.value(
                                              value: DatabaseService()
                                                  .getLiveCities),
                                          StreamProvider<List<TripModel>>.value(
                                              value: DatabaseService()
                                                  .getLiveTrips),
                                        ],
                                        child: ManagementReportScreen(
                                            mList[index]))));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
              itemCount: mList.length,
            )
          : SizedBox(),
    );
  }
}

class FinancialReportScreen extends StatelessWidget {
  NewStatsModel report;

  FinancialReportScreen(this.report);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Financial Report',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: report != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/trlogo.png',
                        height: 60,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Financial Report',
                        style: TextStyle(
                            color: Uti().accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.getWidth(5)),
                      )
                    ],
                  ),
                  Divider(
                    color: Uti().accentColor,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'System gain in ${report.id} :',
                            style: TextStyle(
                                color: Uti().mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.getWidth(5)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ProfitWidget(
                              title: 'Annual Gain',
                              profit: '${report.totalProfit['price']}',
                              count: '${report.totalCount['count']}'),
                          SizedBox(
                            height: 10,
                          ),
                          ProfitWidget(
                              title: 'Semi-annual 1-6',
                              profit: '${report.totalProfit['1st']}',
                              count: '${report.totalCount['1st']}'),
                          SizedBox(
                            height: 10,
                          ),
                          ProfitWidget(
                              title: 'Semi-annual 7-12',
                              profit: '${report.totalProfit['2nd']}',
                              count: '${report.totalCount['2nd']}'),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        'Date : ${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}',
                        style: TextStyle(
                            color: Uti().mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.getWidth(4.5))),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          : SizedBox(),
    );
  }
}

class ProfitWidget extends StatelessWidget {
  String title;

  String profit;

  String count;

  ProfitWidget({this.title, this.profit, this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '- $title :',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.getWidth(4.5)),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              Text('Profits : '),
              Text(
                '$profit L.E',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              Text('Tickets : '),
              Text(
                '$count',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ManagementWidget extends StatelessWidget {
  String title;
  String first;
  String second;
  String third;
  String firstCount;
  String secondCount;
  String thirdCount;

  ManagementWidget(
      {this.title,
      this.first,
      this.second,
      this.third,
      this.firstCount,
      this.secondCount,
      this.thirdCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '- $title :',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.getWidth(4.5)),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('1st : '),
              Text(
                '$first',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
              Text(
                '  ( $firstCount )',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('2nd : '),
              Text(
                '$second',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
              Text(
                '  ( $secondCount )',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('3rd : '),
              Text(
                '$third',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
              Text(
                '  ( $thirdCount )',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ManagementReportScreen extends StatelessWidget {
  NewStatsModel report;

  ManagementReportScreen(this.report);

  String getSource1st(int rank,List<CityModel> mCityList ,List<TripModel> mTripList){
    return report.topCountFirst.length <rank+1 ? '': mCityList.firstWhere((element) =>
    element.id==mTripList.firstWhere((element) =>
    element.id=='${report.topCountFirst.keys.elementAt(rank)}').source).name;
  }

  String getDestination1st(int rank,List<CityModel> mCityList ,List<TripModel> mTripList){
    return report.topCountFirst.length <rank+1 ? '': mCityList.firstWhere((element) => element.id==mTripList.firstWhere((element) => element.id=='${report.topCountFirst.keys.elementAt(rank)}').destination).name;
  }

  String getCount1st(int rank){
    return report.topCountFirst.length <rank+1 ? '': '${report.topCountFirst[report.topCountFirst.keys.elementAt(rank)]}';
  }


  String getSource2nd(int rank,List<CityModel> mCityList ,List<TripModel> mTripList){
    return report.topCountSecond.length <rank+1 ? '': mCityList.firstWhere((element) =>
    element.id==mTripList.firstWhere((element) =>
    element.id=='${report.topCountSecond.keys.elementAt(rank)}').source).name;
  }

  String getDestination2nd(int rank,List<CityModel> mCityList ,List<TripModel> mTripList){
    return report.topCountSecond.length <rank+1 ? '': mCityList.firstWhere((element) => element.id==mTripList.firstWhere((element) => element.id=='${report.topCountSecond.keys.elementAt(rank)}').destination).name;
  }

  String getCount2nd(int rank){
    return report.topCountSecond.length <rank+1 ? '': '${report.topCountSecond[report.topCountSecond.keys.elementAt(rank)]}';
  }
  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<TripModel> mTripList = Provider.of<List<TripModel>>(context);


    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Management report',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mTripList != null && mCityList != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/trlogo.png',
                        height: 60,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Management report',
                        style: TextStyle(
                            color: Uti().accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.getWidth(5)),
                      )
                    ],
                  ),
                  Divider(
                    color: Uti().accentColor,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Most reserved in ${report.id} :',
                            style: TextStyle(
                                color: Uti().mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.getWidth(5)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ManagementWidget(
                            title: 'Semi-annual 1-6',
                            first: '${getSource1st(0,mCityList,mTripList)} to ${getDestination1st(0,mCityList,mTripList)}',
                            firstCount: '${getCount1st(0)}',
                            second: '${getSource1st(1,mCityList,mTripList)} to ${getDestination1st(1,mCityList,mTripList)}',
                            secondCount:'${getCount1st(1)}',
                            third: '${getSource1st(2,mCityList,mTripList)} to ${getDestination1st(2,mCityList,mTripList)}',
                            thirdCount: '${getCount1st(2)}',
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          ManagementWidget(
                            title: 'Semi-annual 7-12',
                            first: '${getSource2nd(0,mCityList,mTripList)} to ${getDestination2nd(0,mCityList,mTripList)}',
                            firstCount: '${getCount2nd(0)}',
                            second: '${getSource2nd(1,mCityList,mTripList)} to ${getDestination2nd(1,mCityList,mTripList)}',
                            secondCount:'${getCount2nd(1)}',
                            third: '${getSource2nd(2,mCityList,mTripList)} to ${getDestination2nd(2,mCityList,mTripList)}',
                            thirdCount: '${getCount2nd(2)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        'Date : ${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}',
                        style: TextStyle(
                            color: Uti().mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.getWidth(4.5))),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          : SizedBox(),
    );
  }
}
