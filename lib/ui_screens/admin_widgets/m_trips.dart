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

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Manage Trips',
            style: TextStyle(
                color: Colors.white,
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
          return TripsCard(
            date: mTripList[index].dateFrom,
              destination: mTripList[index].destination,
            source: mTripList[index].source,

            delete: () async {
              await DatabaseService().deleteTrip(deleteTrip: mTripList[index]);
            },
            edit: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddEditTripScreen(editTrip: mTripList[index],citiesList: mCityList,trainsList: mTrainList)));
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
  String priceOfA ;
  String priceOfB ;
  String stops ;
  Map<String,String> keyWords={};
  String _sourceError = "";
  String _destinationError = "";
  String _trainError = "";
  String _priceAError = "";
  String _priceBError = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editTrip != null) {
      if(widget.citiesList!=null&&widget.trainsList!=null){
        _priceOfClassAController.text = widget.editTrip.priceOfClassA.toString();
        _priceOfClassBController.text = widget.editTrip.priceOfClassB.toString();
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
          backgroundColor: Uti().pinkColor,
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
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: dateFrom,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Depart At',
                  timeLabelText: "Hour",
                  onChanged: (val) {
                    setState(() {
                      print(val);
                      dateFrom = val;

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
                activeBorderColor: Uti().mainColor,
              ),
              SizedBox(
                height: Dimensions.getHeight(2.0),
              ),
              TextFormBuilder(
                hint: "Class B Price",
                keyType: TextInputType.number,
                controller: _priceOfClassBController,
                errorText: _priceBError,
                activeBorderColor: Uti().mainColor,
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
      if (int.parse(source.id) <= int.parse(destination.id)) {
        _noOfStopsController.text =
            (int.parse(destination.id) - int.parse(source.id) - 1).toString();


        if (i >= int.parse(source.id) && i <= int.parse(destination.id)) {
          stopsList.add(citiesList[i - 1]);
        }
      } else {
        if (i >= int.parse(destination.id) && i <= int.parse(source.id)) {
          _noOfStopsController.text =
              (int.parse(source.id) - int.parse(destination.id) - 1).toString();

          if (i >= int.parse(destination.id) && i <= int.parse(source.id)) {
            stopsList.add(citiesList[i - 1]);
          }
        }
      }
    }
  }

  void _apiRequest() async {
     priceOfA = _priceOfClassAController.text;
     priceOfB = _priceOfClassBController.text;
     stops = _noOfStopsController.text;

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
    }  else if (priceOfA == null || priceOfA.isEmpty) {
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
      createSearchKeywordsList();
      if(keyWords.length>0){
        TripModel newTrip = new TripModel(source: sourceCity.id.toString(),
            destination: destinationCity.id.toString(),
            id: widget.editTrip != null ? widget.editTrip.id : '',
            dateFrom: dateFrom,
            dateTo: dateTo,
            priceOfClassA: int.parse(priceOfA),
            priceOfClassB: int.parse(priceOfB),
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
    keyWords['priceA']=priceOfA;
    keyWords['priceB']=priceOfB;
    keyWords['date']=dateFrom.substring(0, 10);

    if(selectedTrain.trainType=='Express'){
      for(int i=0 ; i<stopsList.length; i++){
        keyWords['city${stopsList[i].id.toString()}']='true';
      }
    }


    print(keyWords.toString());
  }

  void clear() {
    setState(() {
      _sourceError = "";
      _destinationError = "";
      _trainError = "";
      _priceAError = "";
      _priceBError = "";
    });
  }
}
