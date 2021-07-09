import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../models/db_model.dart';
import '../../ui_widget/home_widgets/admin_widgets/admin_card.dart';

class ManageReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<StatsModel> mList = Provider.of<List<StatsModel>>(context);
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
                return TripResCard(
                  tripNum: '${mList[index].id}',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReportScreen(mList[index])));
                  },
                );
              },
              itemCount: mList.length,
            )
          : SizedBox(),
    );
  }
}

class ReportScreen extends StatelessWidget {
  StatsModel report;

  ReportScreen(this.report);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Trip:${report.id} Report',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: report.tickets != null
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text("Total tickets booked : ",  style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${report.tickets['countTotal']}",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Text("Total Profit : ",  style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${report.tickets['priceTotal']} L.E",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Divider(thickness: 2,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8),
                child: Text("Detailed info : ",  style: TextStyle(
                  fontSize: 18,
                    fontWeight: FontWeight.w600),),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.getWidth(2),
                        vertical: Dimensions.getHeight(0)),
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      String key = report.tickets.keys.elementAt(index);
                      return key != 'countTotal' && key != 'priceTotal'
                          ? ListTile(
                              title: Row(
                                children: [
                                  Text("$key : "),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${report.tickets[key]}",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            )
                          : SizedBox();
                    },
                    itemCount: report.tickets.length,
                  ),
              ),
            ],
          )
          : SizedBox(),
    );
  }
}
