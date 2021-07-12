import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/ui_screens/ticket_details.dart';
import 'package:flutter_booking_app/wrapper.dart';
import 'package:provider/provider.dart';

import '../models/db_model.dart';

class DatabaseService {
  // Users collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference trainCollection =
      FirebaseFirestore.instance.collection('Trains');
  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('Cars');
  final CollectionReference classCollection =
      FirebaseFirestore.instance.collection('Class');
  final CollectionReference citiesCollection =
      FirebaseFirestore.instance.collection('Cities');
  final CollectionReference tripCollection =
      FirebaseFirestore.instance.collection('Trips');
  final CollectionReference statsCollection =
      FirebaseFirestore.instance.collection('Stats');
  final CollectionReference ticketCollection =
      FirebaseFirestore.instance.collection('Tickets');
  CollectionReference queryTripRef =
      FirebaseFirestore.instance.collection('Trips');

/////////////////////////////////// User ///////////////////////////////////
  //get my user
  Stream<DocumentSnapshot> get getUserById {
    return userCollection.doc(Wrapper.UID).snapshots();
  }

  //upload Image method
  Future uploadImageToStorage({File file, String userId}) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('images/users/$userId.png');

    firebase_storage.UploadTask task = ref.putFile(file);

    /*task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });*/

    // We can still optionally use the Future alongside the stream.
    try {
      //update image
      await task;
      String url = await FirebaseStorage.instance
          .ref('images/users/${userId}.png')
          .getDownloadURL();

      return url;
    } on firebase_storage.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  //updateUserData
  Future<void> updateUserData({UserModel user}) async {
    return await userCollection.doc(user.id).set(user.toJson());
  }

/////////////////////////////////// User ///////////////////////////////////

  /// //////////////////////////////// CAR //////////////////////////////// ///
  //add new car
  Future addCar({CarModel newCar}) async {
    var ref = carsCollection.doc(newCar.id);
    return await ref.set(newCar.toJson());
  }

  //update existing car
  Future updateCar({CarModel updatedCar}) async {
    return await carsCollection.doc(updatedCar.id).update(updatedCar.toJson());
  }

  //delete existing car
  Future deleteCar({CarModel deleteCar}) async {
    return await carsCollection.doc(deleteCar.id).delete();
  }

  // stream for live cars
  Stream<List<CarModel>> get getLiveCars {
    return carsCollection.snapshots().map(CarModel().fromQuery);
  }

  /// //////////////////////////////// CAR //////////////////////////////// ///

  /////////////////////////////////// Train ///////////////////////////////////
  //add new car
  Future addTrain({TrainModel newTrain}) async {
    var ref = trainCollection.doc(newTrain.id);
    return await ref.set(newTrain.toJson());
  }

  //update existing car
  Future updateTrain({TrainModel updatedTrain}) async {
    return await trainCollection
        .doc(updatedTrain.id)
        .update(updatedTrain.toJson());
  }

  //delete existing car
  Future deleteTrain({TrainModel deleteTrain}) async {
    return await trainCollection.doc(deleteTrain.id).delete();
  }

  // stream for live cars
  Stream<List<TrainModel>> get getLiveTrains {
    return trainCollection.snapshots().map(TrainModel().fromQuery);
  }

  /////////////////////////////////// Train ///////////////////////////////////

  /// //////////////////////////////// City //////////////////////////////// ///
  //add new City
  Future addCity({CityModel newCity}) async {
    var ref = citiesCollection.doc(newCity.id.toString());
    return await ref.set(newCity.toJson());
  }

  //update existing car
  Future updateCity({CityModel updatedCity}) async {
    return await citiesCollection
        .doc(updatedCity.id.toString())
        .update(updatedCity.toJson());
  }

  //delete existing car
  Future deleteCity({CityModel deleteCity}) async {
    return await citiesCollection.doc(deleteCity.id.toString()).delete();
  }

  // stream for live cars
  Stream<List<CityModel>> get getLiveCities {
    return citiesCollection
        .orderBy('id', descending: false)
        .snapshots()
        .map(CityModel().fromQuery);
  }

  /// //////////////////////////////// City //////////////////////////////// ///

  /////////////////////////////////// Trips ///////////////////////////////////
  //add new Trips
  Future addTrip({TripModel newTrip}) async {
    var ref = tripCollection.doc(newTrip.id);
    return await ref.set(newTrip.toJson());
  }

  //update existing Trips
  Future updateTrip({TripModel updatedTrip}) async {
    return await tripCollection
        .doc(updatedTrip.id)
        .update(updatedTrip.toJson());
  }

  //delete existing Trips
  Future deleteTrip({TripModel deleteTrip}) async {
    return await tripCollection.doc(deleteTrip.id).delete();
  }

  // stream for live Trips
  Stream<List<TripModel>> get getLiveTrips {
    return tripCollection.orderBy('id').snapshots().map(TripModel().fromQuery);
  }

  // query for live trips
  Stream<List<TripModel>> queryLiveTrips(Query ref) {
    return ref.snapshots().map(TripModel().fromQuery);
  }

  /////////////////////////////////// Trips ///////////////////////////////////

  /// //////////////////////////////// CLASS //////////////////////////////// ///
  //add new car
  Future addClass({ClassModel newClass}) async {
    var ref = classCollection.doc();
    newClass.id = ref.id;
    return await ref.set(newClass.toJson());
  }

  //update existing car
  Future updateClass({ClassModel updatedClass}) async {
    return await classCollection
        .doc(updatedClass.id)
        .update(updatedClass.toJson());
  }

  //delete existing car
  Future deleteClass({ClassModel deleteClass}) async {
    return await classCollection.doc(deleteClass.id).delete();
  }

  // stream for live cars
  Stream<List<ClassModel>> get getLiveClass {
    return classCollection.snapshots().map(ClassModel().fromQuery);
  }

  /// //////////////////////////////// CLASS //////////////////////////////// ///

  /////////////////////////////////// Tickets ///////////////////////////////////
  //book Tickets
  Future addSeat(
      {String id,
      String seat,
      String tripId,
      String car,
      TicketModel ticket,
      BuildContext context}) async {
    var ref = tripCollection
        .doc(tripId)
        .collection('day')
        .doc(ticket.date)
        .collection('cars')
        .doc(car)
        .collection('tickets')
        .doc(id);
    ref.get().then((value) {
      if (value.exists) {
        return ref.update({seat: Wrapper.UID}).then((value) {
          _continueAddSeat(ticket, context);
        });
      } else {
        return ref.set({'id': id, seat: Wrapper.UID}).then((value) {
          _continueAddSeat(ticket, context);
        });
      }
    });
  }

  void _continueAddSeat(TicketModel ticket, BuildContext context) {
    var docRef = ticketCollection.doc();
    ticket.id = docRef.id;
    docRef.set(ticket.toJson()).then((value) async {
      await updateBookingStats(ticket);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => MultiProvider(providers: [
                    StreamProvider<List<CityModel>>.value(
                        value: DatabaseService().getLiveCities),
                    StreamProvider<List<ClassModel>>.value(
                        value: DatabaseService().getLiveClass),
                    StreamProvider<List<TrainModel>>.value(
                        value: DatabaseService().getLiveTrains),
                  ], child: TicketDetails(ticket))));
    });
  }

  //delete Tickets
  Future deleteSeat({TicketModel ticket}) async {
    return await tripCollection
        .doc(ticket.tripId)
        .collection('day')
        .doc(ticket.date)
        .collection('cars')
        .doc(ticket.car)
        .collection('tickets')
        .doc(ticket.row)
        .update({
      '${ticket.seat}': null,
    }).then((value) async {
      await ticketCollection.doc(ticket.id).delete();
    });
  }

  // stream for live Tickets
  Stream<List<SeatModel>> getLiveSeats(
      {String tripId, String carId, String carClass, String date}) {
    return tripCollection
        .doc(tripId)
        .collection('day')
        .doc(date)
        .collection('cars')
        .doc('${carClass}c$carId')
        .collection('tickets')
        .snapshots()
        .map(SeatModel().fromQuery);
  }

  // stream for user Tickets
  Stream<List<TicketModel>> get getMyTickets {
    return ticketCollection
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map(TicketModel().fromQuery);
  }

  // stream for user Tickets
  Stream<List<TicketModel>> ticketsByDay(String date) {
    return ticketCollection
        .where('date', isEqualTo: date)
        .snapshots()
        .map(TicketModel().fromQuery);
  }

  /////////////////////////////////// Tickets ///////////////////////////////////

  /// //////////////////////////////// Report ///////////////////////////////////


  Future updateBookingStats(TicketModel ticket) async {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(ticket.date);

    String year = '${dateTime.year}';
    int month = dateTime.month;

    var ref = statsCollection.doc(year);
    ref.get().then((value) {
      if (value.exists) {
        if (month <= 6) {
          return ref.update({
            'totalProfit.price': FieldValue.increment(ticket.price),
            'totalProfit.1st': FieldValue.increment(ticket.price),
            'totalProfit.$month': FieldValue.increment(ticket.price),

            'totalCount.1st': FieldValue.increment(1),
            'totalCount.count': FieldValue.increment(1),
            'totalCount.$month': FieldValue.increment(1),


            'topProfitFirst.${ticket.tripId}': FieldValue.increment(ticket.price),
            'topCountFirst.${ticket.tripId}': FieldValue.increment(1)
          });
        } else {
          return ref.update({
            'totalProfit.price': FieldValue.increment(ticket.price),
            'totalProfit.$month': FieldValue.increment(ticket.price),
            'totalProfit.2nd': FieldValue.increment(ticket.price),

            'totalCount.count': FieldValue.increment(1),
            'totalCount.2nd': FieldValue.increment(1),
            'totalCount.$month': FieldValue.increment(1),

            'topProfitSecond.${ticket.tripId}':
                FieldValue.increment(ticket.price),
            'topCountSecond.${ticket.tripId}': FieldValue.increment(1)
          });
        }
      } else {
        if (month <= 6) {
          NewStatsModel newReport = NewStatsModel(
              id: year,
              totalProfit: {'price': ticket.price, '1st': ticket.price,'$month': ticket.price,},
              totalCount: {'1st': 1, 'count': 1,'$month': 1,},
              topProfitFirst: {'${ticket.tripId}': ticket.price},
              topCountFirst: {'${ticket.tripId}': 1},
              topProfitSecond: {},topCountSecond: {});
          return ref.set(newReport.toJson());
        } else {
          NewStatsModel newReport = NewStatsModel(
              id: year,
              totalProfit: {'price': ticket.price, '2nd': ticket.price,'$month': ticket.price,},
              totalCount: {'count': 1,'2nd': 1,'$month': 1,},
              topProfitSecond: {'${ticket.tripId}': ticket.price},
              topCountSecond: {'${ticket.tripId}': 1},
              topCountFirst: {},topProfitFirst: {});
          return ref.set(newReport.toJson());
        }
      }
    });
  }

  // stream for reports
  Stream<List<NewStatsModel>> get getLiveReports {
    return statsCollection.snapshots().map(NewStatsModel().fromQuery);
  }

  /// //////////////////////////////// Report ///////////////////////////////////

  ///////////////////////////////// utils ///////////////////////////////////
  Future batch({UserModel user}) async {
    //batch used to add or edit multiple doc at the same time
    var batch = FirebaseFirestore.instance.batch();
    UserModel user;
    for (int i = 0; i > 10; i++) {
      batch.set(userCollection.doc('userId$i'), user.toJson());
    }
    batch.commit();
  }

  Future update(String uid) async {
    return await userCollection.doc(uid).update({'logo': 'value'});
  }

  ///add item to array
/* return await carsCollection.doc(updatedCar.id).update({
  'upvoters': FieldValue.arrayUnion(['12345'])
  });*/

  ///remove item from array
/* return await carsCollection.doc(updatedCar.id).update({
  'user_fav': FieldValue.arrayRemove(['12345'])
  });*/

//////////////////////////////// utils ///////////////////////////////////
}
