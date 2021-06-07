import 'package:flutter/material.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';

class CarIndicator extends StatelessWidget {
  final int carNumber;
  final bool isFull;
  final bool isSelected;
  final Function onTap;

  CarIndicator({this.carNumber,this.isSelected ,this.isFull = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.getWidth(5),
            vertical: Dimensions.getHeight(2)),
        child: Column(
          children: [
            Text(carNumber.toString()),
            SizedBox(
              height: Dimensions.getHeight(0.7),
            ),
            Container(
                height: Dimensions.getHeight(0.75),
                width: Dimensions.getWidth(10),
                decoration: BoxDecoration(
                    color: isSelected ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(2))),
          ],
        ),
      ),
    );
  }
}
