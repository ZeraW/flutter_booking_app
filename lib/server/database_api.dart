import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/wrapper.dart';

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
  final CollectionReference citiesCollection =
  FirebaseFirestore.instance.collection('Cities');

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
    return await carsCollection.doc(newCar.id).set(newCar.toJson());
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
    var ref = trainCollection.doc();
    newTrain.id = ref.id;
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
    var ref = citiesCollection.doc();
    newCity.id = ref.id;
    return await ref.set(newCity.toJson());
  }

  //update existing car
  Future updateCity({CityModel updatedCity}) async {
    return await citiesCollection.doc(updatedCity.id).update(updatedCity.toJson());
  }

  //delete existing car
  Future deleteCity({CityModel deleteCity}) async {
    return await citiesCollection.doc(deleteCity.id).delete();
  }

  // stream for live cars
  Stream<List<CityModel>> get getLiveCities {
    return citiesCollection.snapshots().map(CityModel().fromQuery);
  }

  /// //////////////////////////////// City //////////////////////////////// ///

  ///////////////////////////////// utils ///////////////////////////////////
  Future batch({UserModel user}) async {
    //batch used to add or edit multiple doc at the same time
    var batch = FirebaseFirestore.instance.batch();
    UserModel user;
    for (int i = 0; i > 10; i++) {
      batch.set(userCollection.doc('car:$i'), user.toJson());
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
/*
//post fluff <Message>
Future<void> postFluff({String roomId,Fluff fluff,String hisId}) async {

  final newFluff = chatCollection
      .document(roomId)
      .collection('chat')
      .document();

  await newFluff.setData(fluff.toJson()).then((doc) async{
    print('hop ${newFluff.documentID}');

    //update the chat room
    await chatCollection.document(roomId).updateData({'lastChat':newFluff.documentID });
    //update mySide
    await userCollection.document(Wrapper.UID).collection('friends').document(hisId).updateData({'lastChat':fluff.time });
    //update hisSide
    await userCollection.document(hisId).collection('friends').document(Wrapper.UID).updateData({'lastChat':fluff.time });


  }).catchError((error) {
    print(error);
  });

}*/
