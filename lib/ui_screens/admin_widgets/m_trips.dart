import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/drop_down.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/admin_widgets/admin_card.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ManageTripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<TrainModel> mTrainList = Provider.of<List<TrainModel>>(context);
    List<TripModel> mTripList = Provider.of<List<TripModel>>(context);
    if(mTripList!=null)mTripList.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));


    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Manage Trips',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mTripList != null
          ? ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.getWidth(2),
            vertical: Dimensions.getHeight(1.5)),
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          TripModel trip = mTripList[index];
          return TripsCard(
            tripNum: trip.id.toString(),
            date: '${trip.dateFrom} - ${getDateTo(trip.source, trip.destination, trip.keyWords['trainType'], trip.dateFrom)}',
              destination: mCityList.firstWhere((element) => element.id == trip.destination).name,
            source: mCityList.firstWhere((element) => element.id == trip.source).name,

            delete: () async {
              await DatabaseService().deleteTrip(deleteTrip: trip);
            },
            edit: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddEditTripScreen(editTrip: trip,citiesList: mCityList,trainsList: mTrainList)));
            },
          );
        },
        itemCount: mTripList.length,
      )
          : SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _increment(
                context: context, cityList: mCityList, trainList: mTrainList),
        tooltip: 'Increment',
        backgroundColor: Uti().mainColor.withOpacity(0.9),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _increment({BuildContext context,
    List<CityModel> cityList,
    List<TrainModel> trainList}) {
    cityList != null && trainList != null
        ? Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                AddEditTripScreen(
                  citiesList: cityList,
                  trainsList: trainList,
                )))
        : null;
  }

  String getDateTo(sourceCity,destinationCity,selectedTrain,dateFrom){
    print('koko');
    if(sourceCity!=null &&
        destinationCity!=null &&
        selectedTrain!=null &&
        dateFrom!=null  &&
        dateFrom.isNotEmpty){
      print(dateFrom);
      DateTime dateTime = DateFormat("HH:mm").parse(dateFrom);

      int citydif = (destinationCity - sourceCity);
      int timeDif = citydif.abs() *(selectedTrain == 'Express'? 45:30);

      print(citydif.round());
      TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime.add(Duration(minutes: timeDif)));

      return '${timeOfDay.hour}:${timeOfDay.minute}';

    }else{
      return '';
    }




  }
}

class AddEditTripScreen extends StatefulWidget {
  TripModel editTrip;
  List<TrainModel> trainsList;
  List<CityModel> citiesList;

  AddEditTripScreen({this.editTrip, this.citiesList, this.trainsList});

  @override
  _AddEditTripScreenState createState() => _AddEditTripScreenState();
}

class _AddEditTripScreenState extends State<AddEditTripScreen> {
  TextEditingController _priceOfClassAController = new TextEditingController();
  TextEditingController _tripNumberController = new TextEditingController();

/*
  TextEditingController _priceOfClassBController = new TextEditingController();
*/
  TextEditingController _noOfStopsController = new TextEditingController();
  CityModel sourceCity, destinationCity;
  TrainModel selectedTrain;
  String dateFrom = '00:00', dateTo;
  List<CityModel> stopsList = [];
  String prices ;
  /*String priceOfB ;*/
  String stops ;
  Map<String,String> keyWords={};
  String _sourceError = "";
  String _numberError = "";

  String _destinationError = "";
  String _trainError = "";
  String _priceAError = "";
/*
  String _priceBError = "";
*/


  @override
  void initState() {

    super.initState();
    if (widget.editTrip != null) {
      if(widget.citiesList!=null&&widget.trainsList!=null){
        _priceOfClassAController.text = widget.editTrip.prices.toString();
        _tripNumberController.text = widget.editTrip.id.toString();

/*
        _priceOfClassBController.text = widget.editTrip.priceOfClassB.toString();
*/
        dateFrom = widget.editTrip.dateFrom;
        dateTo = widget.editTrip.dateTo;
        selectedTrain = widget.trainsList.firstWhere((element) => element.id==widget.editTrip.trainId);
        sourceCity = widget.citiesList.firstWhere((element) => element.id==widget.editTrip.source);
        destinationCity = widget.citiesList.firstWhere((element) => element.id==widget.editTrip.destination);
        getStopsBetweenTwoCities(source: sourceCity,
            destination: destinationCity,
            citiesList: widget.citiesList);
      }


    } else {
      dateFrom = '00:00';
      dateTo = '00:00';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            widget.editTrip == null ? 'Add New Trip' : 'Edit Trip',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              TextFormBuilder(
                hint: "Trip Number",
                keyType: TextInputType.number,
                controller: _tripNumberController,
                errorText: _numberError,
                activeBorderColor: Uti().mainColor,
              ),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              widget.citiesList!=null ?DropDownCityList(
                  mList: widget.citiesList,
                  hint: 'Source',
                  selectedItem: sourceCity,
                  errorText: _sourceError,
                  onChange: (CityModel value) {
                    setState(() {
                      sourceCity = value;
                      destinationCity != null ? getStopsBetweenTwoCities(
                          source: sourceCity,
                          destination: destinationCity,
                          citiesList: widget.citiesList) : '';
                      getDateTo();
                    });
                  }):SizedBox(),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              widget.citiesList!=null ?DropDownCityList(
                  mList: widget.citiesList,
                  hint: 'Destination',
                  selectedItem: destinationCity,
                  errorText: _destinationError,
                  onChange: (CityModel value) {
                    setState(() {
                      destinationCity = value;
                      sourceCity != null ? getStopsBetweenTwoCities(
                          source: sourceCity,
                          destination: destinationCity,
                          citiesList: widget.citiesList) : '';
                      getDateTo();
                    });
                  }):SizedBox(),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              widget.trainsList!=null ?DropDownTrainList(
                  mList: widget.trainsList,
                  selectedItem: selectedTrain,
                  errorText: _trainError,
                  onChange: (TrainModel value) {
                    setState(() {
                      selectedTrain = value;
                      getDateTo();
                    });
                  }):SizedBox(),
              SizedBox(
                height: Dimensions.getHeight(1.0),
              ),
              selectedTrain != null && selectedTrain.trainType == 'Express'
                  ? Wrap(
                children: stopsList
                    .map((item) =>
                    Container(
                        decoration: BoxDecoration(border: Border.all()),
                        margin: EdgeInsets.symmetric(
                            horizontal: 4, vertical: 3),
                        padding: EdgeInsets.all(5),
                        child: Text(item.name)))
                    .toList()
                    .cast<Widget>(),
              ) : SizedBox(),
              SizedBox(
                height: Dimensions.getHeight(1.0),
              ),
              DateTimePicker(
                  type: DateTimePickerType.time,
                  initialValue: dateFrom,
                  icon: Icon(Icons.event),
                  timeLabelText: 'Depart At',
                  onChanged: (val) {
                    setState(() {
                      print(val);
                      dateFrom = val;
                      print(val);
                      getDateTo();
                    });
                  }),
             /* SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              DateTimePicker(
                  type: DateTimePickerType.time,
                  initialValue: dateTo,
                  icon: Icon(Icons.event),
                  enabled: false,
                  timeLabelText: 'Arrive At',
                  onChanged: (val) {
                    setState(() {
                      dateTo = val;
                    });
                  }),*/
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              TextFormBuilder(
                hint: "Price",
                keyType: TextInputType.number,
                controller: _priceOfClassAController,
                errorText: _priceAError,
                activeBorderColor: Uti().mainColor,
              ),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
          /*    TextFormBuilder(
                hint: "Class B Price",
                keyType: TextInputType.number,
                controller: _priceOfClassBController,
                errorText: _priceBError,
                activeBorderColor: Uti().mainColor,
              ),*/
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              SizedBox(
                height: Dimensions.getHeight(7.0),
                child: RaisedButton(
                  onPressed: () {
                    _apiRequest();
                  },
                  color: Uti().mainColor,
                  child: Text(
                    widget.editTrip == null ? 'Add Trip' : 'Edit Trip',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.getWidth(4.0),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void getStopsBetweenTwoCities(
      {CityModel source, CityModel destination, List<CityModel> citiesList}) {
    stopsList = [];
    for (int i = 0; i < citiesList.length+1; i++) {
      if (source.id <= destination.id) {
        _noOfStopsController.text =
            (destination.id - source.id - 1).toString();


        if (i >= source.id && i <= destination.id) {
          stopsList.add(citiesList[i - 1]);
        }
      } else {
        if (i >= destination.id && i <= source.id) {
          _noOfStopsController.text =
              (source.id - destination.id - 1).toString();

          if (i >= destination.id && i <= source.id) {
            stopsList.add(citiesList[i - 1]);
          }
        }
      }
    }
  }

  void getDateTo(){
/*
    print('koko');
    if(sourceCity!=null && destinationCity!=null && selectedTrain!=null && dateFrom!=null  && dateFrom.isNotEmpty){
      String trainType = selectedTrain.trainType;
      print(dateFrom);
      DateTime dateTime = DateFormat("HH:mm").parse(dateFrom);

      int from = sourceCity.id;
      int to =  destinationCity.id;
      int timeDif = (to - from)*(trainType == 'Express'? 45:30);

      TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime.add(Duration(minutes: timeDif)));

      dateFrom = timeOfDay.toString();
      print('wawa');
      setState(() {

      });
    }
*/




  }

  void _apiRequest() async {
     prices = _priceOfClassAController.text;
     String tripNum = _tripNumberController.text;

/*
     priceOfB = _priceOfClassBController.text;
*/
     stops = _noOfStopsController.text;

     if (tripNum == null || tripNum.isEmpty) {
    setState(() {
    _numberError = "Please enter Trip Number";
    });
    }else if (sourceCity == null) {
       clear();
      setState(() {
        _sourceError = "Please select source City";
      });
    } else if (destinationCity == null) {
      clear();
      setState(() {
        _destinationError = "Please select destination City";
      });
    } else if (selectedTrain == null) {
      clear();
      setState(() {
        _trainError = "Please select train";
      });
    }  else if (prices == null || prices.isEmpty) {
      clear();
      setState(() {
        _priceAError = "Please enter trip price";
      });
    } /*else if (priceOfB == null || priceOfB.isEmpty) {
      clear();
      setState(() {
        _priceBError = "Please enter class B price";
      });
    } */else {
      clear();
      createSearchKeywordsList();
      if(keyWords.length>0){
        TripModel newTrip = new TripModel(source: sourceCity.id,
            destination: destinationCity.id,
            id: widget.editTrip != null ? widget.editTrip.id : tripNum,
            dateFrom: dateFrom,
            dateTo: dateTo,
            prices: int.parse(prices),
/*
            priceOfClassB: int.parse(priceOfB),
*/
            stops: stopsList,
            keyWords: keyWords,
            numberOfStops: selectedTrain.trainType=='Express'?stops:'0',
            trainId: selectedTrain.id.toString());
        widget.editTrip == null
            ? await DatabaseService().addTrip(newTrip: newTrip)
            : await DatabaseService().updateTrip(updatedTrip: newTrip);
        Navigator.pop(context);
      }
    }
  }

  void createSearchKeywordsList(){
    keyWords.clear();
    keyWords['cityfrom']=sourceCity.id.toString();
    keyWords['cityto']=destinationCity.id.toString();
    keyWords['trainType']=selectedTrain.trainType;
    keyWords['trainId']=selectedTrain.id;
    keyWords['price']=prices;
    keyWords.addAll(selectedTrain.keyWords);
/*
    keyWords['priceB']=priceOfB;
*/
    keyWords['date']=dateFrom;

    if(selectedTrain.trainType=='Express'){
      for(int i=0 ; i<stopsList.length; i++){
        keyWords['city${stopsList[i].id.toString()}']='true';
      }
    }


    print(keyWords.toString());
  }

  void clear() {
    setState(() {
      _numberError = "";
      _sourceError = "";
      _destinationError = "";
      _trainError = "";
      _priceAError = "";
/*
      _priceBError = "";
*/
    });
  }
}
