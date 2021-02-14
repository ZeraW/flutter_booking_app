import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_screens/admin_widgets/m_booking.dart';
import 'package:flutter_booking_app/ui_screens/admin_widgets/m_cars.dart';
import 'package:flutter_booking_app/ui_screens/admin_widgets/m_citys.dart';
import 'package:flutter_booking_app/ui_screens/admin_widgets/m_trains.dart';
import 'package:flutter_booking_app/ui_screens/admin_widgets/m_trips.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/admin_widgets/admin_card.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

import '../../models/db_model.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
      child: Column(
        children: [
          SizedBox(height: Dimensions.getHeight(1)),
          AdminCard(
              title: 'Manage Trains',
              open: StreamProvider<List<TrainModel>>.value(
                  value: DatabaseService().getLiveTrains,
                  child: ManageTrainsScreen())),
          AdminCard(
              title: 'Manage Cars',
              open: StreamProvider<List<CarModel>>.value(
                  value: DatabaseService().getLiveCars,
                  child: ManageCarsScreen())),
          AdminCard(
              title: 'Manage Cities',
              open: StreamProvider<List<CityModel>>.value(
                  value: DatabaseService().getLiveCities,
                  child: ManageCitiesScreen())),
          AdminCard(
              title: 'Manage Trips',
              open: MultiProvider(providers: [
                StreamProvider<List<CityModel>>.value(
                    value: DatabaseService().getLiveCities),
                StreamProvider<List<TrainModel>>.value(
                    value: DatabaseService().getLiveTrains),
              ], child: ManageTripsScreen())),
          AdminCard(title: 'Manage Booking', open: ManageBookingsScreen())
        ],
      ),
    );
  }
}
