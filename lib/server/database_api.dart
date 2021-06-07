import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/ui_screens/ticket_details.dart';
import 'package:flutter_booking_app/wrapper.dart';
import 'package:provider/provider.dart';

import '../models/db_model.dart';
import '../ui_widget/home_widgets/admin_widgets/admin_card.dart';

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
      await updateTicketStats(ticket);
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
    }).then((value) async{
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

  Future updateTicketStats(TicketModel ticket) async {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(ticket.date);
    String currentMonth = ('${dateTime.year}-${dateTime.month}');
    print(currentMonth.toString());

    var ref = statsCollection.doc(ticket.tripId);
    ref.get().then((value) {
      if (value.exists) {
        return ref.update({
          'tickets.price$currentMonth': FieldValue.increment(ticket.price),
          'tickets.count$currentMonth': FieldValue.increment(1),
          'tickets.priceTotal': FieldValue.increment(ticket.price),
          'tickets.countTotal': FieldValue.increment(1)
        });
      } else {
        StatsModel newStats = StatsModel(id: ticket.tripId, tickets: {
          'price$currentMonth': ticket.price,
          'count$currentMonth': 1,
          'priceTotal': ticket.price,
          'countTotal': 1,
        });
        return ref.set(newStats.toJson());
      }
    });

/*    return await statsCollection.doc(ticket.tripId).update({
      'month.price$currentMonth': FieldValue.increment(ticket.price),
      'month.count$currentMonth': FieldValue.increment(1)
    });*/
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
