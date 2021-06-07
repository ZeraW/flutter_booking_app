import 'package:flutter/material.dart';
import 'package:flutter_booking_app/server/pick_seat_manage.dart';
import 'package:provider/provider.dart';

import 'car_indicator.dart';

class SelectCar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Consumer<PickSeatManage>(
            builder: (context, pickSeat, child) {
              return Wrap(
                children: List<Map<int, bool>>.generate(
                    pickSeat.currentTrain.carCount[pickSeat.carList.firstWhere((element) => element.carClass == pickSeat.currentCarClass).id],
                        (counter) => {counter + 1: false})
                    .map((item) => CarIndicator(
                  carNumber: item.keys.first,
                  isFull: item.values.first,
                  isSelected: pickSeat.currentCar==item.keys.first,
                  onTap: () {
                    pickSeat.switchCar(item.keys.first);
                  },
                ))
                    .toList()
                    .cast<Widget>(),
              );
            }),
      ),
    );
  }



}
