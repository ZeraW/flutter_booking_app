import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';

class PickSeatManage extends ChangeNotifier {
  int currentCar = 1;
  String tripId,
      currentCarClass,
      currentSeat = '',
      pickedRow = '',
      pickedSeat = '';
  TrainModel currentTrain;
  TicketModel ticket;

  List<CarModel> carList;

  PickSeatManage(
      {this.tripId,
      this.currentTrain,
      this.ticket,
      this.currentCarClass,
      this.carList});

  void switchCar(int car) {
    currentCar = car;
    currentSeat = '';
    pickedRow = '';
    pickedSeat = '';
    notifyListeners();
  }

  void pickSeat({String row, String seat}) {
    currentSeat = '$row$seat';
    this.pickedRow = row;
    this.pickedSeat = seat;
    notifyListeners();
  }

  bool isSeatPicked() {
    return currentSeat.isNotEmpty;
  }



/*void updateList(List<SeatModel> newList) {
    if (currentCarClass == 'A') {
      fixedList = List<SeatModel>.generate(
        carList.firstWhere((element) => element.id == 'A').capacity,
        (counter) => SeatModel(id: 'R${counter + 1}'),
      );
    } else {
      fixedList = List<SeatModel>.generate(
        carList.firstWhere((element) => element.id == 'B').capacity,
        (counter) => SeatModel(id: 'R${counter + 1}'),
      );
    }
    for (SeatModel item in newList) {
      final index = fixedList.indexOf(fixedList.firstWhere((element) => element.id ==item.id));
      fixedList[index] = item;
    }
    notifyListeners();
  }*/
}
