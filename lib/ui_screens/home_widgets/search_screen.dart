import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/search_manage.dart';
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
  String redDotText = 'Destination',greenDotText = 'Source', source,
      destination, trainType,_classError='',
      date = DateTime.now().toString().substring(0, 10);
  bool foodDrink = false;
  TextEditingController controller = new TextEditingController();
  List<CityModel> _searchResult = [];

  ClassModel selectedClass;
  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<ClassModel> mClassList = Provider.of<List<ClassModel>>(context);

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
            roundedContainer(child: Row(
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
                    child: Icon(
                      Icons.swap_vertical_circle,
                      color: Colors.grey,
                    )),
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
            mClassList!=null?roundedContainer(
                child:DropDownClassList(
                    mList: mClassList,
                    hint: 'Class',
                    selectedItem: selectedClass,
                    enableBorder: true,
                    errorText: _classError,
                    onChange: (ClassModel value) {
                      setState(() {
                        selectedClass = value;
                      });
                    })):SizedBox(),

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
    } else if (selectedClass == null) {
      Toast.show("Please Choose Class", context,
          backgroundColor: Colors.redAccent,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    }else if (source == null||source.isEmpty) {
      Toast.show("Please Choose Source", context,
          backgroundColor: Colors.redAccent,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    }else if (destination == null||destination.isEmpty) {
      Toast.show("Please Choose Destination", context,
          backgroundColor: Colors.redAccent,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    } else {
      print('so: ${source}');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                    create: (context) => SearchManage(
                      date: date,
                      carClass: selectedClass,
                      destination: destination,
                      foodDrink: foodDrink,
                      source: source,
                      trainType: trainType,
                    ),
                    child: SearchResultScreen(),
                  )));
    }
  }

  void showCityDialog(List<CityModel> mCityList, int type) {
    onTap(CityModel city){
      if (type == 0) {
        greenDotText = city.name;
        source = city.id.toString();
      } else {
        redDotText = city.name;
        destination = city.id.toString();
      }
      setState(() {});
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                title: new Text("Choose Station"),
                content: Container(
                  height: Dimensions.getHeight(70), // Change as per your requirement
                  width: 300.0,
                  child: Column(
                    children: [

                      Flexible(fit: FlexFit.tight,flex: 3,child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(Icons.search),
                            title: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                  hintText: 'Search', border: InputBorder.none),
                              onChanged: (text){
                                _searchResult.clear();
                                mCityList.forEach((city) {
                                  if (city.name.contains(text))
                                    _searchResult.add(city);
                                  print(_searchResult.length);
                                });
                                setState(() {});
                              },
                            ),
                            trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () {

                              controller.clear();
                              _searchResult.clear();
                              setState(() {});

                            },),
                          ),
                        ),
                      )),
                      Flexible(
                        flex: 15,
                        child: ListView.builder(
                          itemBuilder: (ctx, index) {
                            CityModel city = _searchResult.isEmpty ?mCityList[index]:_searchResult[index];
                            return ListTile(
                              title: Text(city.name),
                              onTap: ()=>onTap(city),
                            );
                          },
                          itemCount:_searchResult.isEmpty ? mCityList.length : _searchResult.length,
                        ),
                      ),
                    ],
                  ),
                ));
          },
        );
      },
    );

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
          ),
        ],
      ),
    );
  }
}


