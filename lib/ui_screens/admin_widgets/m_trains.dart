import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/drop_down.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/admin_widgets/admin_card.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ManageTrainsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<TrainModel> mList = Provider.of<List<TrainModel>>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Manage Trains',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mList != null
          ? ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.getWidth(2),
                  vertical: Dimensions.getHeight(1.5)),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                TrainModel currentTrain = mList[index];
                print(currentTrain.carCount.length);
                return TrainCard(
                  title: mList[index].id,
                  type: mList[index].trainType,
                  delete: () async {
                    await DatabaseService()
                        .deleteTrain(deleteTrain: mList[index]);
                  },
                  edit: () async {

                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEditTrainScreen(editTrain: currentTrain)));
                  },
                );
              },
              itemCount: mList.length,
            )
          : SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _increment(context),
        tooltip: 'Increment',
        backgroundColor: Uti().mainColor.withOpacity(0.9),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _increment(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => AddEditTrainScreen()));
  }
}

class AddEditTrainScreen extends StatefulWidget {
  TrainModel editTrain;

  AddEditTrainScreen({this.editTrain});

  @override
  _AddEditTrainScreenState createState() => _AddEditTrainScreenState();
}
class _AddEditTrainScreenState extends State<AddEditTrainScreen> {
  TextEditingController _trainIdController = new TextEditingController();

  String trainType;
  String _trainTypeError = "";
  String _trainIdError = "";

  @override
  void initState() {
    super.initState();
    if (widget.editTrain != null) {
      print(widget.editTrain.carCount.length);
      _trainIdController.text = widget.editTrain.id;
      trainType = widget.editTrain.trainType;
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
            widget.editTrain == null ? 'Add New Train' : 'Edit Train',
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
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Train Number",
                controller: _trainIdController,
                errorText: _trainIdError,
                activeBorderColor: Uti().mainColor,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              DropDownStringList(
                errorText: _trainTypeError,
                mList: ['Express', 'Super Fast'],
                hint: 'Train Type',
                selectedItem: trainType,
                onChange: (String value) {
                  setState(() {
                    trainType = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              /*TextFormBuilder(
                hint: "Number of Class A Cars",
                keyType: TextInputType.number,
                controller: _classAnumController,
                errorText: _classAnumError,
                activeBorderColor: Uti().mainColor,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Number of Class B Cars",
                keyType: TextInputType.number,
                controller: _classBnumController,
                errorText: _classBnumError,
                activeBorderColor: Uti().mainColor,

              ),*/
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              SizedBox(
                height: Dimensions.getHeight(7.0),
                child: RaisedButton(
                  onPressed: () {
                    _apiRequest();
                  },
                  color: Uti().mainColor,
                  child: Text(
                    'Continue',
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

  void _apiRequest() async {
    String trainName = _trainIdController.text;

    if (trainName == null || trainName.isEmpty) {
      setState(() {
        _trainIdError = "Please enter train name";
      });
    } else if (trainType == null || trainType.isEmpty) {
      clear();
      setState(() {
        _trainTypeError = "Please select train type";
      });
    } else {
      clear();
      //do request
      TrainModel newTrain = TrainModel(
          id: widget.editTrain != null ? widget.editTrain.id : trainName,
          trainType: trainType,
          carCount:
              widget.editTrain != null ? widget.editTrain.carCount : null);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MultiProvider(providers: [
                    StreamProvider<List<CarModel>>.value(
                        value: DatabaseService().getLiveCars),
                    StreamProvider<List<ClassModel>>.value(
                        value: DatabaseService().getLiveClass),
                  ], child: ContinueAddTrain(editTrain: newTrain,edit: widget.editTrain != null))));
    }
  }

  void clear() {
    setState(() {
      _trainTypeError = "";
      _trainIdError = "";
    });
  }
}

class ContinueAddTrain extends StatefulWidget {
  TrainModel editTrain;
  bool edit;

  ContinueAddTrain({this.editTrain,this.edit});

  @override
  _ContinueAddTrainState createState() => _ContinueAddTrainState();
}
class _ContinueAddTrainState extends State<ContinueAddTrain> {
  Map<String, int> newCarCount = {};
  Map<String,String> keyWords={};

  @override
  void initState() {
    super.initState();
    if (widget.editTrain.carCount != null) {
      newCarCount.clear();
      newCarCount.addAll(widget.editTrain.carCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CarModel> mCarList = Provider.of<List<CarModel>>(context);
    List<ClassModel> mClassList = Provider.of<List<ClassModel>>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Train Cars',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mCarList != null && mClassList != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.getWidth(2),
                        vertical: Dimensions.getHeight(1.5)),
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      var keys = newCarCount.keys.toList();
                      var val = newCarCount[keys[index]];

                      CarModel car = mCarList.firstWhere((element) => element.id == keys[index],orElse: ()=>null);
                      ClassModel classModel =car!=null ? mClassList.firstWhere((element) => element.id == car.carClass, orElse: () =>null):null;
                      if(car ==null){
                        WidgetsBinding.instance.addPostFrameCallback((_){

                          // Add Your Code here.
                          newCarCount.removeWhere((key, value) => key== keys[index]);
                          setState(() {});
                        });


                      }
                      return TrainCarCard(
                        title: car !=null ? car.id:'car deleted',
                        className: classModel!=null ?classModel.className:'class Deleted',
                        count: val.toString(),
                        delete: () async {
                          setState(() {
                            newCarCount.removeWhere((key, value) => key== keys[index]);
                          });
                        },
                        edit: () async {
                          showCityDialog(key: keys[index],value:val ,carList: mCarList);
                        },
                      );
                    },
                    itemCount: newCarCount.length,
                  ),
                  SizedBox(
                    height: Dimensions.getHeight(3.0),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.getWidth(5)),
                    child: SizedBox(
                      height: Dimensions.getHeight(7.0),
                      child: RaisedButton(
                        onPressed: () => showCityDialog(carList: mCarList),
                        color: Uti().greenColor,
                        child: Text(
                          'Add New Car',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.getWidth(4.0),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.getHeight(3.0),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.getWidth(5)),
                    child: SizedBox(
                      height: Dimensions.getHeight(7.0),
                      child: RaisedButton(
                        onPressed: () {
                          _apiRequest(mCarList);
                        },
                        color: Uti().mainColor,
                        child: Text(
                          'Save Train',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.getWidth(4.0),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void _apiRequest(List<CarModel> carList) async {
    if (newCarCount == null || newCarCount.isEmpty) {
      Toast.show('Please Add A Car', context);
    } else {
      //do request
      createSearchKeywordsList(carList);
      widget.editTrain.carCount = newCarCount;
      !widget.edit ? await DatabaseService().addTrain(newTrain: widget.editTrain)
          : await DatabaseService().updateTrain(updatedTrain: widget.editTrain);

      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void showCityDialog({String key, int value, List<CarModel> carList}) {
    TextEditingController _countController = new TextEditingController();
    CarModel selectedCar;
    String _countError = "", _carError = "", title = 'Add Car';

    if (key != null) {
      selectedCar = carList.firstWhere((element) => element.id == key);
      _countController.text = value.toString();
      title = 'Edit Car';
    }

    onTap() {
      newCarCount.removeWhere((key, value) => key== selectedCar.id);
      newCarCount[selectedCar.id] = int.parse(_countController.text);
      setState(() {});
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                title: Text(title),
                content: Container(
                  height: 250.0, // Change as per your requirement
                  width: 300.0,
                  child: Column(
                    children: [
                      DropDownCarList(
                          mList: carList,
                          hint: 'Car',
                          selectedItem: selectedCar,
                          errorText: _carError,
                          onChange: (CarModel value) {
                            setState(() {
                              selectedCar = value;
                            });
                          }),
                      SizedBox(
                        height: Dimensions.getHeight(3.0),
                      ),
                      TextFormBuilder(
                        hint: "Car Count",
                        controller: _countController,
                        keyType: TextInputType.number,
                        errorText: _countError,
                        activeBorderColor: Uti().mainColor,
                      ),
                      SizedBox(
                        height: Dimensions.getHeight(3.0),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.getWidth(5)),
                        child: SizedBox(
                          height: Dimensions.getHeight(7.0),
                          child: RaisedButton(
                            onPressed: () => onTap(),
                            color: Uti().greenColor,
                            child: Text(
                              title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.getWidth(4.0),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
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

  void createSearchKeywordsList(List<CarModel> carList){
    keyWords.clear();
    var keys = newCarCount.keys.toList();


    keyWords['type']=widget.editTrain.trainType.toString();

    for(int i=0 ; i<newCarCount.length; i++){
      keyWords['${carList.firstWhere((element) => element.id==keys[i]).carClass}']='ture';
    }


    widget.editTrain.keyWords = keyWords;
  }
}
