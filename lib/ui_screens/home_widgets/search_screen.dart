import 'package:flutter/material.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int sourceOrDestination = 0;
  String redDotText = 'Source', greenDotText = 'Destination';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50)),
          child: Center(
            child: Image.asset(
              "assets/images/otoraty.jpeg",
              fit: BoxFit.cover,
              height: Dimensions.getWidth(40.0),
              width: Dimensions.getWidth(100.0),
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.getWidth(4),
        ),
        roundedContainer(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWithDot(text: greenDotText, dotColor: Colors.green),
                Container(
                  height: Dimensions.getHeight(0.1),
                  width: Dimensions.getWidth(65),
                  color: Colors.black,
                  margin:
                      EdgeInsets.symmetric(vertical: Dimensions.getHeight(2)),
                ),
                textWithDot(text: redDotText, dotColor: Colors.red),
              ],
            ),
            GestureDetector(
                onTap: () {
                  if (sourceOrDestination == 0) {
                    setState(() {
                      sourceOrDestination = 1;
                      redDotText = 'Destination';
                      greenDotText = 'Source';
                    });
                  } else {
                    setState(() {
                      sourceOrDestination = 0;
                      redDotText = 'Source';
                      greenDotText = 'Destination';
                    });
                  }
                },
                child: Icon(Icons.person_pin)),
          ],
        )),
        roundedContainer(child: Row(children: [
          Spacer(),
          Text('14/12/2020'),
          Spacer(),
          Icon(Icons.timer)
        ],)),
        roundedContainer(child: Row(children: [
          Spacer(),
          Text('14/12/2020'),
          Spacer(),
          Icon(Icons.timer)
        ],)),
        roundedContainer(child: Row(children: [
          Spacer(),
          Text('14/12/2020'),
          Spacer(),
          Icon(Icons.timer)
        ],)),
        roundedContainer(child: Row(children: [
          Spacer(),
          Text('14/12/2020'),
          Spacer(),
          Icon(Icons.timer)
        ],)),

      ],
    );
  }

  Widget roundedContainer({Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom:Dimensions.getWidth(2) ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      width: Dimensions.getWidth(84),
      padding: EdgeInsets.all(Dimensions.getWidth(3)),
      child: child,
    );
  }

  Widget textWithDot({Color dotColor, Function onTap, String text}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: dotColor,
          ),
          SizedBox(
            width: Dimensions.getWidth(2.5),
          ),
          Text(
            text,
            style: TextStyle(fontSize: Dimensions.getWidth(4)),
          )
        ],
      ),
    );
  }
}
