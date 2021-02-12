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
  String title;
  int capacity;
  Function edit, delete;

  CarCard({this.title, this.capacity, this.edit, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          'Class : $title',
          style: TextStyle(fontSize: Dimensions.getWidth(4.5)),
        ),
        subtitle: Text(
          'Capacity : $capacity',
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
class CityCard extends StatelessWidget {
  String title;
  Function edit, delete;

  CityCard({this.title, this.edit, this.delete});

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

class TrainCard extends StatelessWidget {
  String title;
  int aCars;
  int bCars;

  Function edit, delete;

  TrainCard({this.title, this.aCars,this.bCars, this.edit, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          '$title',
          style: TextStyle(fontSize: Dimensions.getWidth(4.5)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.getHeight(1),),

            Text(
              "Class ( A ) Cars : $aCars",
              style: TextStyle(
                  fontSize: Dimensions.getWidth(3.5), fontWeight: FontWeight.w600),
            ),
            Text(
              "Class ( B ) Cars : $bCars",
              style: TextStyle(
                  fontSize: Dimensions.getWidth(3.5), fontWeight: FontWeight.w600),
            ),
          ],
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

