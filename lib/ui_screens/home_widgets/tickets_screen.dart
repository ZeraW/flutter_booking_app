import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_screens/ticket_details.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/search_result_widgets/search_widgets.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:provider/provider.dart';


class MyTicketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<List<CityModel>>.value(
          value: DatabaseService().getLiveCities),
      StreamProvider<List<TripModel>>.value(
          value: DatabaseService().getLiveTrips),
      StreamProvider<List<TicketModel>>.value(
          value: DatabaseService().getMyTickets),
    ], child: TicketsWidget());
  }
}

class TicketsWidget extends StatefulWidget {
  @override
  _TicketsWidgetState createState() => _TicketsWidgetState();
}

class _TicketsWidgetState extends State<TicketsWidget> {
  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<TicketModel> mTicketList = Provider.of<List<TicketModel>>(context);
    List<TripModel> mTripList = Provider.of<List<TripModel>>(context);

    return Container(
      height: double.infinity,
      child: mTicketList != null && mTripList!=null
          ? mTicketList.length > 0
          ? ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.getWidth(5),
            vertical: Dimensions.getHeight(1.5)),
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          String source = mCityList
              .firstWhere((element) =>
          element.id.toString() == mTicketList[index].source)
              .name;
          String destination = mCityList
              .firstWhere((element) =>
          element.id.toString() == mTicketList[index].destination)
              .name;

          TripModel trip = mTripList.firstWhere((element) => element.id == mTicketList[index].tripId,orElse: ()=>null);
          return UserMoneyTripsCard(
            stopCount: (int.parse(mTicketList[index].source)-int.parse(mTicketList[index].destination)).abs(),
              dateFrom: mTicketList[index].departAt.toString(),
            dateTo: mTicketList[index].arriveAt.toString(),
            destination: destination,
            source: source,
            timeExtra: trip!=null ? trip.keyWords['trainType'] == 'Express'? 45 :30 : 35,

            type: '',
            onCancel: ()async{
              await DatabaseService().deleteSeat(ticket: mTicketList[index]);
            },

            stops: 'Date : ${mTicketList[index].date}',
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MultiProvider(providers: [
                        StreamProvider<List<CityModel>>.value(
                            value: DatabaseService().getLiveCities),
                        StreamProvider<List<ClassModel>>.value(
                            value: DatabaseService().getLiveClass),
                        StreamProvider<List<TrainModel>>.value(
                            value: DatabaseService().getLiveTrains),
                      ], child: TicketDetails(mTicketList[index]))));
            },
          );
        },
        itemCount: mTicketList.length,
      )
          : Center(
        child: Text(
          'No Trips Today',
          style: TextStyle(
              fontSize: Dimensions.getWidth(5),
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
