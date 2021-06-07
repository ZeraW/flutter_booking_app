import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/server/pick_seat_manage.dart';
import 'package:flutter_booking_app/ui_screens/payment.dart';
import 'package:flutter_booking_app/ui_widget/pick_seat_widgets/car_seats.dart';
import 'package:flutter_booking_app/ui_widget/pick_seat_widgets/select_car.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class PickSeatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Select Seat',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: Container(
        height: Dimensions.getHeight(100),
        width: Dimensions.getWidth(100),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Uti().pinkColor,
              Uti().accentColor,
            ],
            stops: [0.1, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.getWidth(5),
                      vertical: Dimensions.getHeight(1)),
                  child: Text(
                    'Select car',
                    style: TextStyle(
                        fontSize: Dimensions.getWidth(4),
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  )),
              SelectCar(),
              MultiProvider(providers: [
                StreamProvider<List<SeatModel>>.value(
                    value: DatabaseService().getLiveSeats(
                      date: Provider.of<PickSeatManage>(context, listen: false)
                            .ticket.date,
                        carClass:
                            Provider.of<PickSeatManage>(context, listen: false)
                                .currentCarClass,
                        tripId:
                            Provider.of<PickSeatManage>(context, listen: false)
                                .tripId,
                        carId: Provider.of<PickSeatManage>(context, listen: true)
                            .currentCar
                            .toString())),
              ], child: CarSeats()),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.getHeight(2)),
                  height: Dimensions.getHeight(7.0),
                  width: Dimensions.getWidth(65),
                  child: RaisedButton(
                    onPressed: () async{
                      Provider.of<PickSeatManage>(context, listen: false)
                              .isSeatPicked()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PaymentScreen(
                                    ticketModel: Provider.of<PickSeatManage>(context, listen: false).ticket,
                                      tripId:  Provider.of<PickSeatManage>(context, listen: false).tripId,
                                      row: Provider.of<PickSeatManage>(context, listen: false).pickedRow,
                                      seat: Provider.of<PickSeatManage>(context, listen: false).pickedSeat,
                                      car: '${Provider.of<PickSeatManage>(context, listen: false).currentCarClass}c${Provider.of<PickSeatManage>(context, listen: false).currentCar}')))
                          : print('no');
                    },
                    color: Color(0xffE43141),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.getWidth(4.0),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
