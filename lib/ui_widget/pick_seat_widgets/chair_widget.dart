import 'package:flutter/material.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/server/pick_seat_manage.dart';
import 'package:provider/provider.dart';

class Chair extends StatelessWidget {
  final String rowId, chairId, car, tripId,picked;
  final bool isBooked, isMe;

  Chair(
      {this.rowId,
      this.chairId,
      this.car,
      this.isBooked,
      this.tripId,
      this.picked,
      this.isMe});

  @override
  Widget build(BuildContext context) {
    bool isPicked =  picked=='$rowId$chairId';
    return GestureDetector(
      onTap: !isBooked
          ? () async {
              Provider.of<PickSeatManage>(context, listen: false)
                  .pickSeat(seat: chairId,row: rowId);
              print(tripId);

              print('object');
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/chair.png',
          color: isBooked ||isPicked?
          (isPicked ? Colors.green : isMe?Colors.blue: Colors.red) : Colors.black,
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
