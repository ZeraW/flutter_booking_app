import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/admin_widgets/admin_card.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatelessWidget {
  final String source, destination, date, trainType, carClass;
  final bool foodDrink;

  SearchResultScreen(
      {this.source,
      this.destination,
      @required this.date,
      this.trainType,
      this.carClass,
      this.foodDrink});

  @override
  Widget build(BuildContext context) {
    Query queryRef;

    if (trainType != null) {
      if (trainType == 'Super Fast') {
        queryRef = FirebaseFirestore.instance
            .collection('Trips')
            .where('keyWords.date', isEqualTo: date)
            .where('keyWords.trainType', isEqualTo: 'Super Fast');
        if (source != null && destination == null) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.date', isEqualTo: date)
              .where('keyWords.trainType', isEqualTo: 'Super Fast')
              .where('keyWords.cityfrom', isEqualTo: source);
        } else if (destination != null && source == null) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.date', isEqualTo: date)
              .where('keyWords.trainType', isEqualTo: 'Super Fast')
              .where('keyWords.cityto', isEqualTo: source);
        } else {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.date', isEqualTo: date)
              .where('keyWords.trainType', isEqualTo: 'Super Fast')
              .where('keyWords.cityfrom', isEqualTo: source)
              .where('keyWords.cityto', isEqualTo: destination);
        }
      } else if (trainType == 'Express') {
        queryRef = FirebaseFirestore.instance
            .collection('Trips')
            .where('keyWords.date', isEqualTo: date)
            .where('keyWords.trainType', isEqualTo: 'Express');
        if (source != null) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.date', isEqualTo: date)
              .where('keyWords.trainType', isEqualTo: 'Express')
              .where('keyWords.city$source', isEqualTo: 'true');
        }
      }
    }

    return MultiProvider(providers: [
      StreamProvider<List<CityModel>>.value(
          value: DatabaseService().getLiveCities),
      StreamProvider<List<TrainModel>>.value(
          value: DatabaseService().getLiveTrains),
      StreamProvider<List<TripModel>>.value(
          value: DatabaseService().queryLiveTrips(queryRef)),
    ], child: ResultScreen());
  }
}

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<TrainModel> mTrainList = Provider.of<List<TrainModel>>(context);
    List<TripModel> mTripList = Provider.of<List<TripModel>>(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Manage Trips',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mTripList != null
          ? ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.getWidth(2),
                  vertical: Dimensions.getHeight(1.5)),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return TripsCard(
                  date: mTripList[index].dateFrom,
                  destination: mTripList[index].destination,
                  source: mTripList[index].source,
                  delete: () async {},
                  edit: () async {},
                );
              },
              itemCount: mTripList.length,
            )
          : SizedBox(),
    );
  }
}
