import 'package:flutter/material.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';

class AdminCard extends StatelessWidget {
  String title;
  Widget open;

  AdminCard({this.title, this.open});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: Dimensions.getWidth(4.5)),
        ),
        leading: Icon(Icons.storage, size: Dimensions.getWidth(6)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => open));
        },
        shape: Border.all(color: Colors.redAccent, width: 5),
      ),
    );
  }
}
class CarCard extends StatelessWidget {
  String title,className;
  Function edit, delete;

  CarCard({this.title, this.className, this.edit, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          '$title',
          style: TextStyle(fontSize: Dimensions.getWidth(4.5)),
        ),
        subtitle: Text(
          'Class : $className',
          style: TextStyle(
              fontSize: Dimensions.getWidth(3.5), fontWeight: FontWeight.w600),
        ),
        leading: Image.asset(
          'assets/images/wagon.png',
          height: Dimensions.getWidth(8),
          width: Dimensions.getWidth(8),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(onTap: edit, child: Icon(Icons.edit)),
            SizedBox(
              width: Dimensions.getWidth(4),
            ),
            GestureDetector(onTap: delete, child: Icon(Icons.delete_forever)),
          ],
        ),
        shape: Border.all(color: Colors.redAccent, width: 5),
      ),
    );
  }
}
class TrainCarCard extends StatelessWidget {
  String title,className,count;
  Function edit, delete;

  TrainCarCard({this.title, this.className,this.count, this.edit, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        title: Text(
          '$title',
          style: TextStyle(fontSize: Dimensions.getWidth(4.5),fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Text(
              'Class : $className',
              style: TextStyle(
                  fontSize: Dimensions.getWidth(3.5), fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 3,),
            Text(
              'Car Count : $count',
              style: TextStyle(
                  fontSize: Dimensions.getWidth(3.5), fontWeight: FontWeight.w600),
            ),
          ],
        ),
        leading: Image.asset(
          'assets/images/wagon.png',
          height: Dimensions.getWidth(8),
          width: Dimensions.getWidth(8),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(onTap: edit, child: Icon(Icons.edit)),
            SizedBox(
              width: Dimensions.getWidth(4),
            ),
            GestureDetector(onTap: delete, child: Icon(Icons.delete_forever)),
          ],
        ),
        shape: Border.all(color: Colors.redAccent, width: 5),
      ),
    );
  }
}
class CityCard extends StatelessWidget {
  String title;
  Function edit, delete;
  Key key;
  CityCard({this.title, this.key,this.edit, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          '$title',
          style: TextStyle(fontSize: Dimensions.getWidth(4.5)),
        ),
        leading: Icon(Icons.location_city,size: Dimensions.getWidth(8),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(onTap: edit, child: Icon(Icons.edit)),
            SizedBox(
              width: Dimensions.getWidth(4),
            ),
            GestureDetector(onTap: delete, child: Icon(Icons.delete_forever)),
          ],
        ),
        shape: Border.all(color: Colors.redAccent, width: 5),
      ),
    );
  }
}
class ClassCard extends StatelessWidget {
  String title;
  Function edit, delete;

  ClassCard({this.title,this.edit, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          'Class : $title',
          style: TextStyle(fontSize: Dimensions.getWidth(4.5)),
        ),
        leading: Icon(Icons.class__outlined,size: Dimensions.getWidth(8),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(onTap: edit, child: Icon(Icons.edit)),
            SizedBox(
              width: Dimensions.getWidth(4),
            ),
            GestureDetector(onTap: delete, child: Icon(Icons.delete_forever)),
          ],
        ),
        shape: Border.all(color: Colors.redAccent, width: 5),
      ),
    );
  }
}
class TrainCard extends StatelessWidget {
  String title,type;
  Function edit, delete;

  TrainCard({this.title, this.type, this.edit, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          '$title',
          style: TextStyle(fontSize: Dimensions.getWidth(4.5)),
        ),
        subtitle: Text(
          "Type : $type",
          style: TextStyle(
              fontSize: Dimensions.getWidth(3.5), fontWeight: FontWeight.w600),
        ),
        leading: Image.asset(
          'assets/images/train.png',
          height: Dimensions.getWidth(8),
          width: Dimensions.getWidth(8),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(onTap: edit, child: Icon(Icons.edit)),
            SizedBox(
              width: Dimensions.getWidth(4),
            ),
            GestureDetector(onTap: delete, child: Icon(Icons.delete_forever)),
          ],
        ),
        shape: Border.all(color: Colors.redAccent, width: 5),
      ),
    );
  }
}
class TripsCard extends StatelessWidget {
  String date,tripNum;
  String source;
  String destination;

  Function edit, delete;

  TripsCard({this.date,this.tripNum, this.source,this.destination, this.edit, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          "Trip : $tripNum",
          style: TextStyle(fontSize: Dimensions.getWidth(4), fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Text(
                  'From: ',
                  style: TextStyle(color: Colors.green,fontSize: Dimensions.getWidth(4)),
                ),
                Text(
                  '$source',
                  style: TextStyle(fontSize: Dimensions.getWidth(4)),
                ),
                Text(
                  '  To: ',
                  style: TextStyle(color: Colors.red,fontSize: Dimensions.getWidth(4)),
                ),
                Text(
                  '$destination',
                  style: TextStyle(fontSize: Dimensions.getWidth(4)),
                ),
              ],
            ),
            SizedBox(height: 4,),
            Text(
              "$date",
              style: TextStyle(
                  fontSize: Dimensions.getWidth(3.5), fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2,),
          ],
        ),
        leading: Image.asset(
          'assets/images/destination.png',
          height: Dimensions.getWidth(8),
          width: Dimensions.getWidth(8),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(onTap: edit, child: Icon(Icons.edit)),
            SizedBox(
              width: Dimensions.getWidth(4),
            ),
            GestureDetector(onTap: delete, child: Icon(Icons.delete_forever)),
          ],
        ),
        shape: Border.all(color: Colors.redAccent, width: 5),
      ),
    );
  }
}


class TripResCard extends StatelessWidget {
  String tripNum;
  String source;
  String destination;
  Function onTap;


  TripResCard({this.tripNum, this.source,this.destination,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap:onTap,
        title: Padding(
          padding: source !=null? EdgeInsets.only(top: 10):EdgeInsets.all(0),
          child: Text(
            "Trip : $tripNum",
            style: TextStyle(fontSize: Dimensions.getWidth(4), fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: source ==null||destination ==null?null:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Text(
                  'From: ',
                  style: TextStyle(color: Colors.green,fontSize: Dimensions.getWidth(4)),
                ),
                Text(
                  '$source',
                  style: TextStyle(fontSize: Dimensions.getWidth(4)),
                ),
                Text(
                  '  To: ',
                  style: TextStyle(color: Colors.red,fontSize: Dimensions.getWidth(4)),
                ),
                Text(
                  '$destination',
                  style: TextStyle(fontSize: Dimensions.getWidth(4)),
                ),
              ],
            ),
            SizedBox(height: 4,),
          ],
        ),
        leading: Image.asset(
          'assets/images/destination.png',
          height: Dimensions.getWidth(8),
          width: Dimensions.getWidth(8),
        ),
        shape: Border.all(color: Colors.redAccent, width: 5),
      ),
    );
  }
}

class TripRepCard extends StatelessWidget {
  String title;
  IconData icon;
  Function onTap;


  TripRepCard({this.title, this.icon,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap:onTap,
        title: Text(
          "$title",
          style: TextStyle(fontSize: Dimensions.getWidth(4), fontWeight: FontWeight.bold),
        ),
        leading: Icon(
          icon,
          size: Dimensions.getWidth(8),
        ),
        shape: Border.all(color: Colors.redAccent, width: 5),
      ),
    );
  }
}


