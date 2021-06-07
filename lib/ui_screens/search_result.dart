import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/server/pick_seat_manage.dart';
import 'package:flutter_booking_app/server/search_manage.dart';
import 'package:flutter_booking_app/ui_screens/pick_seat.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/search_result_widgets/search_widgets.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:flutter_booking_app/wrapper.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchManage>(builder: (context, search, child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Add Your Code here.
        search.queryRef == null ? search.updateQuery() : null;
      });

      print('a');
      return search.queryRef != null
          ? MultiProvider(
              providers: [
                  StreamProvider<List<CityModel>>.value(
                      value: DatabaseService().getLiveCities),
                  StreamProvider<List<TrainModel>>.value(
                      value: DatabaseService().getLiveTrains),
                  StreamProvider<List<CarModel>>.value(
                      value: DatabaseService().getLiveCars),
                  StreamProvider<List<TripModel>>.value(
                      value: DatabaseService().queryLiveTrips(search.queryRef)),
                ],
              child: ResultScreen(
                  source: search.source,
                  date: search.date,
                  carClass: search.carClass,
                  destination: search.destination))
          : SizedBox();
    });
  }
}

class ResultScreen extends StatefulWidget {
  String date, source, destination;
  ClassModel carClass;

  ResultScreen({this.date, this.source, this.destination, this.carClass});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  DateFormat dateFormat = DateFormat("HH:mm");
  DateFormat timeFormat = DateFormat("HH:mm");
  TextEditingController controller = new TextEditingController();
  List<CityModel> _searchResult = [];

  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<TrainModel> mTrainList = Provider.of<List<TrainModel>>(context);
    List<TripModel> mTripList = Provider.of<List<TripModel>>(context);
    List<CarModel> mCarList = Provider.of<List<CarModel>>(context);
    if(mTripList!=null)mTripList.sort((a, b) => a.source.compareTo(b.source));
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Trips',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Uti().pinkColor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RoundedContainer(
                              onTap: () => showCityDialog(mCityList, 0),
                              text: 'From',
                              child: TextWithDot(
                                  dotColor: Colors.green,
                                  text: widget.source != null && mCityList!=null
                                      ? mCityList.firstWhere((element) =>
                                              element.id ==
                                              int.parse(widget.source))
                                          .name
                                      : 'Source')),
                          GestureDetector(
                              onTap: () {
                                if(mTripList!=null)mTripList.clear();
                                Provider.of<SearchManage>(context, listen: false)
                                    .swapSourceWithDestination();
                              },
                              child: Icon(Icons.swap_horiz)),
                          RoundedContainer(
                              onTap: () => showCityDialog(mCityList, 1),
                              text: 'To',
                              child: TextWithDot(
                                  dotColor: Colors.red,
                                  text: widget.destination != null &&mCityList!=null
                                      ? mCityList.firstWhere((element) =>
                                              element.id ==
                                              int.parse(widget.destination))
                                          .name
                                      : 'Destination')),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    mTripList != null && mTripList.isNotEmpty?  ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.getWidth(5),
                          vertical: Dimensions.getHeight(1.5)),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        String source = mCityList.firstWhere((element) => element.id == int.parse(widget.source)).name;
                        String destination = mCityList.firstWhere((element) => element.id == int.parse(widget.destination)).name;
                        String price = (mTripList[index].prices.abs()+((int.parse(widget.source) - int.parse(widget.destination)).abs() * widget.carClass.price)).toString();
                        return UserMoneyTripsCard(
                          dateFrom: getDepartTime(mTripList[index].dateFrom, mTripList[index].source),
                          dateTo: getArrivalTime(getDepartTime(mTripList[index].dateFrom, mTripList[index].source)),
                          price:price,
                          destination: destination,
                          source: source,
                          stops: mTripList[index].keyWords['trainType'] == 'Express'?'Stops : ${(int.parse(widget.source) - int.parse(widget.destination)).abs().toString()}':'',
                          onTap: () async {
                            TicketModel newTicket = TicketModel(
                                date: widget.date,
                                source: Provider.of<SearchManage>(context,
                                        listen: false)
                                    .source,
                                destination: Provider.of<SearchManage>(context,
                                        listen: false)
                                    .destination,
                                carClass: widget.carClass.id,
                                userName: Wrapper.UNAME,
                                trainId:mTripList[index].trainId ,
                                tripId: mTripList[index].id.toString(),
                                userId: Wrapper.UID,
                                price: int.parse(price),
                                arriveAt: timeFormat.format(
                                    dateFormat.parse(getArrivalTime(getDepartTime(mTripList[index].dateFrom, mTripList[index].source)))),
                                departAt: timeFormat.format(dateFormat
                                    .parse(getDepartTime(mTripList[index].dateFrom, mTripList[index].source))));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChangeNotifierProvider(
                                        create: (context) => PickSeatManage(
                                            ticket: newTicket,
                                            currentTrain: mTrainList.firstWhere(
                                                (element) =>
                                                    element.id ==
                                                    mTripList[index].trainId),
                                            carList: mCarList,
                                            currentCarClass: widget.carClass.id,
                                            tripId: mTripList[index].id),
                                        child: PickSeatScreen())));
                          },
                        );
                      },
                      itemCount: mTripList.length,
                    ): Text('No Trips found',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  ],
                ),
              ],
            ),
    );
  }

  String getDepartTime(String date,int dateStop){
    String trainType = Provider.of<SearchManage>(context, listen: false).trainType;
    DateTime dateTime = DateFormat("HH:mm").parse(date);

    int myStop = int.parse(widget.source);
    int timeDif = (myStop - dateStop)* (trainType == 'Express'? 45:30);
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime.add(Duration(minutes: timeDif)));

    return '${timeOfDay.hour}:${timeOfDay.minute}';
  }

  String getArrivalTime(String date){
    String trainType = Provider.of<SearchManage>(context, listen: false).trainType;
    DateTime dateTime = DateFormat("HH:mm").parse(date);

    int from = int.parse(widget.source);
    int to = int.parse(widget.destination);
    int timeDif = (to - from)*(trainType == 'Express'? 45:30);

    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime.add(Duration(minutes: timeDif)));
    print(timeOfDay);

    return '${timeOfDay.hour}:${timeOfDay.minute}';
  }

  void showCityDialog(List<CityModel> mCityList, int type) {
    onTap(CityModel city) {
      if (type == 0) {
        Provider.of<SearchManage>(context, listen: false)
            .updateSource(city.id.toString());
      } else {
        Provider.of<SearchManage>(context, listen: false)
            .updateDestination(city.id.toString());
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
                  height: Dimensions.getHeight(70),
                  // Change as per your requirement
                  width: 300.0,
                  child: Column(
                    children: [
                      Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Icon(Icons.search),
                                title: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none),
                                  onChanged: (text) {
                                    _searchResult.clear();
                                    mCityList.forEach((city) {
                                      if (city.name.contains(text))
                                        _searchResult.add(city);
                                      print(_searchResult.length);
                                    });
                                    setState(() {});
                                  },
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    controller.clear();
                                    _searchResult.clear();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                        flex: 15,
                        child: ListView.builder(
                          itemBuilder: (ctx, index) {
                            CityModel city = _searchResult.isEmpty
                                ? mCityList[index]
                                : _searchResult[index];
                            return ListTile(
                              title: Text(city.name),
                              onTap: () => onTap(city),
                            );
                          },
                          itemCount: _searchResult.isEmpty
                              ? mCityList.length
                              : _searchResult.length,
                        ),
                      ),
                    ],
                  ),
                ));
          },
        );
      },
    );

    /*showDialog(
        context: context,
         builder: (BuildContext context) { return AlertDialog(
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
                       Provider.of<SearchManage>(context, listen: false)
                           .updateSource(mCityList[index].id);
                     } else {
                       Provider.of<SearchManage>(context, listen: false)
                           .updateDestination(mCityList[index].id);
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
         ); });*/
  }
}
