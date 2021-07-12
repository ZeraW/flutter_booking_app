import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/pick_seat_manage.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/wrapper.dart';
import 'package:provider/provider.dart';

import 'chair_widget.dart';

class CarSeats extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<SeatModel> mList = Provider.of<List<SeatModel>>(context);



    return Consumer<PickSeatManage>(builder: (context, pickSeat, child) {
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: Dimensions.getHeight(1)),
          width: Dimensions.getWidth(90),
          height: Dimensions.getHeight(55),
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(20)),
          child: mList != null
              ? ListView.builder(
                  // get car count and divided it on 5 (cuz ever row has 5 seat)  .round to cast it back to int value
                  itemCount: (pickSeat.carList.firstWhere((element) => element.carClass == pickSeat.ticket.carClass).seats / 4).round(),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  itemBuilder: (BuildContext context, int index) {
                    SeatModel currentRow = mList.firstWhere(
                        (element) => element.id == 'R${index + 1}',
                        orElse: () => null);
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: index == 3 || index == 7 ? 20 : 0),
                      child: Row(
                        children: [
                          Chair(
                              rowId: 'R${index + 1}',
                              chairId: 'one',
                              isMe: currentRow != null && currentRow.one != null && currentRow.one == Wrapper.UID,
                              picked: pickSeat.currentSeat,
                              isBooked: currentRow != null &&
                                  currentRow.one != null &&
                                  currentRow.one.isNotEmpty),
                          Chair(
                              rowId: 'R${index + 1}',
                              chairId: 'two',
                              isMe: currentRow != null && currentRow.two != null && currentRow.two == Wrapper.UID,
                              picked: pickSeat.currentSeat,
                              isBooked: currentRow != null &&
                                  currentRow.two != null &&
                                  currentRow.two.isNotEmpty),
                          Spacer(),
                          Chair(
                              rowId: 'R${index + 1}',
                              chairId: 'three',
                              isMe: currentRow != null &&
                                  currentRow.three != null &&
                                  currentRow.three == Wrapper.UID,
                              picked: pickSeat.currentSeat,
                              isBooked: currentRow != null &&
                                  currentRow.three != null &&
                                  currentRow.three.isNotEmpty),
                          Chair(
                              rowId: 'R${index + 1}',
                              chairId: 'four',
                              isMe: currentRow != null &&
                                  currentRow.four != null &&
                                  currentRow.four == Wrapper.UID,
                              picked: pickSeat.currentSeat,
                              isBooked: currentRow != null &&
                                  currentRow.four != null &&
                                  currentRow.four.isNotEmpty),
                          /*Chair(
                              rowId: 'R${index + 1}',
                              chairId: 'five',
                              isMe: currentRow != null &&
                                  currentRow.five != null &&
                                  currentRow.five == Wrapper.UID,
                              picked: pickSeat.currentSeat,
                              isBooked: currentRow != null &&
                                  currentRow.five != null &&
                                  currentRow.five.isNotEmpty),*/
                        ],
                      ),
                    );
                  },
                )
              : SizedBox(),
        ),
      );
    });
  }
}
