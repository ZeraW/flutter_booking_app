import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/drop_down.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/admin_widgets/admin_card.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ManageTrainsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<TrainModel> mList = Provider.of<List<TrainModel>>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().pinkColor,
          title: Text(
            'Manage Trains',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body:  mList != null
          ? ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.getWidth(2),
            vertical: Dimensions.getHeight(1.5)),
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return TrainCard(
            title: mList[index].name,
            aCars:  mList[index].classAcount,
            bCars:  mList[index].classBcount,
            delete: () async {
              await DatabaseService().deleteTrain(deleteTrain: mList[index]);
            },
            edit: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          AddEditTrainScreen(editTrain: mList[index])));
            },
          );
        },
        itemCount: mList.length,
      )
          : SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _increment(context),
        tooltip: 'Increment',
        backgroundColor: MyColors().mainColor.withOpacity(0.9),
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
  TextEditingController _classAnumController = new TextEditingController();
  TextEditingController _classBnumController = new TextEditingController();
  String trainType;
  String _trainTypeError = "";

  String _trainIdError = "";
  String _classAnumError = "";
  String _classBnumError = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editTrain != null) {
      _trainIdController.text = widget.editTrain.name;
      _classAnumController.text = widget.editTrain.classAcount.toString();
      _classBnumController.text = widget.editTrain.classBcount.toString();
      trainType= widget.editTrain.trainType;
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
            widget.editTrain == null ? 'Add New Car' : 'Edit Car',
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
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Train Name",
                controller: _trainIdController,
                errorText: _trainIdError,
                activeBorderColor: MyColors().mainColor,

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
              TextFormBuilder(
                hint: "Number of Class A Cars",
                keyType: TextInputType.number,
                controller: _classAnumController,
                errorText: _classAnumError,
                activeBorderColor: MyColors().mainColor,
              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              TextFormBuilder(
                hint: "Number of Class B Cars",
                keyType: TextInputType.number,
                controller: _classBnumController,
                errorText: _classBnumError,
                activeBorderColor: MyColors().mainColor,

              ),
              SizedBox(
                height: Dimensions.getHeight(3.0),
              ),
              SizedBox(
                height: Dimensions.getHeight(7.0),
                child: RaisedButton(
                  onPressed: () {
                    _apiRequest();
                  },
                  color: MyColors().mainColor,
                  child: Text(
                    widget.editTrain == null ? 'Add Train' : 'Edit Train',
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
    String classAcount = _classAnumController.text;
    String classBcount = _classBnumController.text;

    if (trainName == null || trainName.isEmpty) {
      setState(() {
        _trainIdError = "Please enter train name";
      });
    } else if (trainType == null || trainType.isEmpty) {
      clear();
      setState(() {
        _trainTypeError = "Please select train type";
      });
    }else if (classAcount == null || classAcount.isEmpty) {
      clear();
      setState(() {
        _classAnumError = "Please enter car count";
      });
    } else if (classBcount == null || classBcount.isEmpty) {
      clear();
      setState(() {
        _classBnumError = "Please enter car count";
      });
    } else {
      clear();
      //do request
      TrainModel newTrain = TrainModel(
        id: widget.editTrain != null? widget.editTrain.id:'',
          name: trainName,
          trainType: trainType,
          classAcount: int.parse(classAcount),
          classBcount: int.parse(classBcount));
      widget.editTrain == null
          ? await DatabaseService().addTrain(newTrain: newTrain)
          : await DatabaseService().updateTrain(updatedTrain: newTrain);

      Navigator.pop(context);
    }
  }

  void clear() {
    setState(() {
      _trainTypeError="";
      _trainIdError = "";
      _classAnumError = "";
      _classBnumError = "";
    });
  }
}
