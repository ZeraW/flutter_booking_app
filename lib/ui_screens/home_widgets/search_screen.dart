import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/ui_screens/search_result.dart';
import 'package:flutter_booking_app/ui_widget/drop_down.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int sourceOrDestination = 0;
  String redDotText = 'Destination',
      greenDotText = 'Source',
      source,
      destination,
      trainType,
      carClass,
      date = DateTime.now().toString().substring(0, 10);
  bool foodDrink = false;

  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);

    return ListView(
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
        Column(
          children: [
            roundedContainer(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWithDot(
                        text: greenDotText,
                        dotColor: Colors.green,
                        onTap: () => showCityDialog(mCityList, 0)),
                    Container(
                      height: Dimensions.getHeight(0.1),
                      width: Dimensions.getWidth(65),
                      color: Colors.black,
                      margin: EdgeInsets.symmetric(
                          vertical: Dimensions.getHeight(1.5)),
                    ),
                    textWithDot(
                        text: redDotText,
                        dotColor: Colors.red,
                        onTap: () => showCityDialog(mCityList, 1)),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        String textHolder, valueHolder;
                        textHolder = redDotText;
                        valueHolder = source;
                        source = destination;
                        destination = valueHolder;
                        redDotText = greenDotText;
                        greenDotText = textHolder;
                      });
                    },
                    child: Icon(Icons.person_pin)),
              ],
            )),
            GestureDetector(
              onTap: _selectDate,
              child: roundedContainer(
                  child: SizedBox(
                height: Dimensions.getHeight(3.5),
                child: Row(
                  children: [Spacer(), Text(date), Spacer(), Icon(Icons.timer)],
                ),
              )),
            ),
            roundedContainer(
                child: DropDownStringList(
              enableBorder: false,
              mList: ['Express', 'Super Fast'],
              selectedItem: trainType,
              hint: 'Train type',
              onChange: (String value) {
                setState(() {
                  trainType = value;
                });
              },
            )),
            roundedContainer(
                child: DropDownStringList(
              enableBorder: false,
              mList: ['A', 'B'],
              selectedItem: carClass,
              hint: 'Class',
              onChange: (String value) {
                setState(() {
                  carClass = value;
                });
              },
            )),
            GestureDetector(
              onTap: () {
                setState(() {
                  foodDrink = !foodDrink;
                });
              },
              child: roundedContainer(
                  child: SizedBox(
                height: Dimensions.getHeight(3.5),
                child: Row(
                  children: [
                    Spacer(),
                    Text('Food & Drinks'),
                    Spacer(),
                    Icon(
                      Icons.check_circle_outline,
                      color: foodDrink ? Colors.green : Colors.grey,
                    )
                  ],
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimensions.getHeight(2)),
              height: Dimensions.getHeight(7.0),
              width: Dimensions.getWidth(65),
              child: RaisedButton(
                onPressed: () {
                  _search(context);
                },
                color: Color(0xffE43141),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  "Search",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.getWidth(4.0),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        date = picked.toString().substring(0, 10);
        print(date);
      });
  }

  _search(BuildContext context) async {
    if (trainType == null) {
      Toast.show("Please Choose Train type", context,
          backgroundColor: Colors.redAccent,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    }else if (carClass == null) {
      Toast.show("Please Choose Class", context,
          backgroundColor: Colors.redAccent,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SearchResultScreen(
                    date: date,
                    carClass: carClass,
                    destination: destination,
                    foodDrink: foodDrink,
                    source: source,
                    trainType: trainType,
                  )));
    }
  }

  void showCityDialog(List<CityModel> mCityList, int type) {
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text("Choose City"),
          content: Container(
            height: 300.0, // Change as per your requirement
            width: 300.0,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(mCityList[index].name),
                  onTap: () {
                    if (type == 0) {
                      greenDotText = mCityList[index].name;
                      source = mCityList[index].id;
                    } else {
                      redDotText = mCityList[index].name;
                      destination = mCityList[index].id;
                    }
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                );
              },
              itemCount: mCityList.length,
            ),
          ),
        ));
  }

  Widget roundedContainer({Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.getWidth(2)),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      width: Dimensions.getWidth(84),
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.getWidth(2), horizontal: Dimensions.getWidth(3)),
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
