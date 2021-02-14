import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/ui_widget/drop_down.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ManageTripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<TrainModel> mTrainList = Provider.of<List<TrainModel>>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().pinkColor,
          title: Text(
            'Manage Trips',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _increment(
            context: context, cityList: mCityList, trainList: mTrainList),
        tooltip: 'Increment',
        backgroundColor: MyColors().mainColor.withOpacity(0.9),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _increment(
      {BuildContext context,
      List<CityModel> cityList,
      List<TrainModel> trainList}) {
    cityList != null && trainList != null
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddEditTripScreen(
                      citiesList: cityList,
                      trainsList: trainList,
                    )))
        : null;
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
  TextEditingController _priceOfClassBController = new TextEditingController();
  TextEditingController _noOfStopsController = new TextEditingController();
  CityModel sourceCity, destinationCity;
  TrainModel selectedTrain;
  String dateFrom, dateTo;
  List<CityModel> stopsList = [];

  String _sourceError = "";
  String _destinationError = "";
  String _dateFromError = "";
  String _dateToError = "";
  String _trainError = "";
  String _priceAError = "";
  String _priceBError = "";
  String _noOfStopsError = "";
  String _stopsError = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editTrip != null) {
      _priceOfClassAController.text = widget.editTrip.priceOfClassA.toString();
      _priceOfClassBController.text = widget.editTrip.priceOfClassB.toString();
      _noOfStopsController.text = widget.editTrip.numberOfStops.toString();
      dateFrom = widget.editTrip.dateFrom;
      dateTo = widget.editTrip.dateTo;
    } else {
      dateFrom = DateTime.now().toString();
      dateTo = DateTime.now().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().pinkColor,
          title: Text(
            widget.editTrip == null ? 'Add New Trip' : 'Edit Trip',
            style: TextStyle(
                color: Colors.white,
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
              DropDownCityList(
                  mList: widget.citiesList,
                  hint: 'Source',
                  selectedItem: sourceCity,
                  errorText: _sourceError,
                  onChange: (CityModel value) {
                    setState(() {
                      sourceCity = value;
                      destinationCity!=null ? getStopsBetweenTwoCities(source: sourceCity,destination: destinationCity,citiesList: widget.citiesList):'';
                    });
                  }),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              DropDownCityList(
                  mList: widget.citiesList,
                  hint: 'Destination',
                  selectedItem: destinationCity,
                  errorText: _destinationError,
                  onChange: (CityModel value) {
                    setState(() {
                      destinationCity = value;
                      sourceCity!=null ? getStopsBetweenTwoCities(source: sourceCity,destination: destinationCity,citiesList: widget.citiesList):'';

                    });
                  }),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              DropDownTrainList(
                  mList: widget.trainsList,
                  selectedItem: selectedTrain,
                  errorText: _trainError,
                  onChange: (TrainModel value) {
                    setState(() {
                      selectedTrain = value;
                    });
                  }),
              SizedBox(
                height: Dimensions.getHeight(1.0),
              ),
              selectedTrain != null && selectedTrain.trainType == 'Express'
                  ? Wrap(
                children: stopsList
                    .map((item) => Container(
                    decoration: BoxDecoration(border: Border.all()),
                    margin: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
                    padding: EdgeInsets.all(5),
                    child: Text(item.name)))
                    .toList()
                    .cast<Widget>(),
              ):SizedBox(),
              SizedBox(
                height: Dimensions.getHeight(1.0),
              ),
              DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: dateFrom,
                  use24HourFormat: false,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Depart At',
                  timeLabelText: "Hour",
                  onChanged: (val) {
                    setState(() {
                      print(val);
                      dateFrom = val;
                      DateTime tempDate = new DateFormat("yyyy-MM-dd h:m").parse(val);
                      print(tempDate.toString());
                    });
                  }),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: dateTo,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  use24HourFormat: false,
                  icon: Icon(Icons.event),
                  dateLabelText: 'Arrive At',
                  timeLabelText: "Hour",
                  onChanged: (val) {
                    setState(() {
                      dateTo = val;
                    });
                  }),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              TextFormBuilder(
                hint: "Class A Price",
                keyType: TextInputType.number,
                controller: _priceOfClassAController,
                errorText: _priceAError,
                activeBorderColor: MyColors().mainColor,
              ),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              TextFormBuilder(
                hint: "Class B Price",
                keyType: TextInputType.number,
                controller: _priceOfClassBController,
                errorText: _priceBError,
                activeBorderColor: MyColors().mainColor,
              ),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              SizedBox(
                height: Dimensions.getHeight(7.0),
                child: RaisedButton(
                  onPressed: () {
                    _apiRequest();
                  },
                  color: MyColors().mainColor,
                  child: Text(
                    widget.editTrip == null ? 'Add Trip' : 'Edit Trip',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.getWidth(4.0),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getStopsBetweenTwoCities(
      {CityModel source, CityModel destination, List<CityModel> citiesList}) {
    stopsList =[];
    for(int i=0; i<citiesList.length ; i++){
      if(int.parse(source.id)<=int.parse(destination.id)){
        _noOfStopsController.text = (int.parse(destination.id)-int.parse(source.id)-1).toString();



        if(i>int.parse(source.id) && i<int.parse(destination.id)){
          stopsList.add(citiesList[i-1]);
        }

      }else{
        if(i>=int.parse(destination.id) && i<=int.parse(source.id)){
          _noOfStopsController.text = (int.parse(source.id)-int.parse(destination.id)-1).toString();

          if(i>int.parse(destination.id) && i<int.parse(source.id)){
            stopsList.add(citiesList[i-1]);
          }
        }
      }
    }




  }

  void _apiRequest() async {
    String priceOfA = _priceOfClassAController.text;
    String priceOfB = _priceOfClassBController.text;
    String stops = _noOfStopsController.text;

    if (sourceCity == null) {
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
    } else if (dateFrom == null || dateFrom.isEmpty) {
      clear();
      setState(() {
        _dateFromError = "Please select departure date";
      });
    } else if (dateTo == null || dateTo.isEmpty) {
      clear();
      setState(() {
        _dateToError = "Please select arrival date";
      });
    } else if (priceOfA == null || priceOfA.isEmpty) {
      clear();
      setState(() {
        _priceAError = "Please enter class A price";
      });
    } else if (priceOfB == null || priceOfB.isEmpty) {
      clear();
      setState(() {
        _priceBError = "Please enter class B price";
      });
    } else {
      clear();

      print('${stopsList.toString().toString()}');
      //do request
      /* TripModel newTrip = TripModel(
          id: widget.editTrip != null ? widget.editTrip.id : '',
          name: TripName,
          classAcount: int.parse(classAcount),
          classBcount: int.parse(classBcount));
      widget.editTrip == null
          ? await DatabaseService().addTrip(newTrip: newTrip)
          : await DatabaseService().updateTrip(updatedTrip: newTrip);

      Navigator.pop(context);*/
    }
  }

  void clear() {
    setState(() {
      _sourceError = "";
      _destinationError = "";
      _dateFromError = "";
      _dateToError = "";
      _trainError = "";
      _priceAError = "";
      _priceBError = "";
      _noOfStopsError = "";
      _stopsError = "";
    });
  }
}
