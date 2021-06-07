import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/search_result_widgets/search_widgets.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class TimeTableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<List<CityModel>>.value(
          value: DatabaseService().getLiveCities),
      StreamProvider<List<TripModel>>.value(
          value: DatabaseService().queryLiveTrips(FirebaseFirestore.instance
              .collection('Trips').orderBy('dateFrom')
              /*.where('keyWords.date',
                  isEqualTo: DateTime.now().toString().substring(0, 10))*/)),
    ], child: TimeTable());
  }
}

class TimeTable extends StatefulWidget {
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<TripModel> mTripList = Provider.of<List<TripModel>>(context);
    return Container(
      height: double.infinity,
      child: mTripList != null
          ? mTripList.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.getWidth(5),
                      vertical: Dimensions.getHeight(1.5)),
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    String source = mCityList
                        .firstWhere((element) =>
                    element.id == mTripList[index].source)
                        .name;
                    String destination = mCityList
                        .firstWhere((element) =>
                    element.id == mTripList[index].destination)
                        .name;
                    return UserMoneyTripsCard(
                      dateFrom: mTripList[index].dateFrom.toString(),
                      dateTo: mTripList[index].dateTo.toString(),
                      destination: destination,
                      source: source,
                      type: mTripList[index].keyWords['trainType'] == 'Express'? 'Express': 'Super Fast',

                      stops: mTripList[index].keyWords['trainType'] == 'Express'?'Stops : ${(mTripList[index].source - mTripList[index].destination).abs().toString()}':'',
                      onTap: () async {
                        /*TicketModel newTicket = TicketModel(
                                date: mTripList[index].dateFrom,
                                source: Provider.of<SearchManage>(context,
                                        listen: false)
                                    .source,
                                destination: Provider.of<SearchManage>(context,
                                        listen: false)
                                    .destination,
                                carClass: widget.carClass.id,
                                userName: Wrapper.UNAME,
                                userId: Wrapper.UID,
                                price: widget.carClass == 'A' ? 150 : 100,
                                arriveAt: timeFormat.format(
                                    dateFormat.parse(mTripList[index].dateTo)),
                                departAt: timeFormat.format(dateFormat
                                    .parse(mTripList[index].dateFrom)));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChangeNotifierProvider(
                                        create: (context) => PickSeatManage(
                                            ticket: newTicket,
                                            currentTrain: mTrainList.firstWhere(
                                                (element) =>
                                                    element.id ==
                                                    mTripList[index].trainId),
                                            carList: mCarList,
                                            currentCarClass: widget.carClass.id,
                                            tripId: mTripList[index].id),
                                        child: PickSeatScreen())));*/
                      },
                    );
                  },
                  itemCount: mTripList.length,
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
