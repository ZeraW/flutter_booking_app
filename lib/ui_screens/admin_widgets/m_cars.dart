import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/drop_down.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/admin_widgets/admin_card.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ManageCarsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<CarModel> mList = Provider.of<List<CarModel>>(context);
    List<ClassModel> mClassList = Provider.of<List<ClassModel>>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Manage Cars',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mList != null && mClassList != null
          ? ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.getWidth(2),
                  vertical: Dimensions.getHeight(1.5)),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                ClassModel classModel = mClassList.firstWhere((element) => element.id == mList[index].carClass , orElse: () => null);
                return CarCard(
                  title: mList[index].id,
                  className: classModel!=null ?classModel.className:'class deleted',
                  delete: () async {
                    await DatabaseService().deleteCar(deleteCar: mList[index]);
                  },
                  edit: () async {
                    if (mClassList != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddEditCarScreen(
                                  editCar: mList[index],
                                  classList: mClassList)));
                    }
                  },
                );
              },
              itemCount: mList.length,
            )
          : SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _increment(context, mClassList),
        tooltip: 'Increment',
        backgroundColor: Uti().mainColor.withOpacity(0.9),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _increment(BuildContext context, var mClassList) {
    if (mClassList != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AddEditCarScreen(classList: mClassList)));
    }
  }
}

class AddEditCarScreen extends StatefulWidget {
  CarModel editCar;
  List<ClassModel> classList;

  AddEditCarScreen({this.editCar, this.classList});

  @override
  _AddEditCarScreenState createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  TextEditingController _carNumController = new TextEditingController();
  TextEditingController _seatsNumberController = new TextEditingController();

  String _carClassError = "";
  String _carNumError = "";
  String _seatsNumError = "";

  ClassModel selectedClass;

  @override
  void initState() {
    super.initState();
    if (widget.editCar != null) {
      _carNumController.text = widget.editCar.id.toString();
      _seatsNumberController.text = widget.editCar.seats.toString();

      selectedClass = widget.classList
          .firstWhere((element) => element.id == widget.editCar.carClass, orElse: () => null);
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
            widget.editCar == null ? 'Add New Car' : 'Edit Car',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: Dimensions.getHeight(3.0),
            ),
            TextFormBuilder(
              hint: "Car Number",
              controller: _carNumController,
              errorText: _carNumError,
              activeBorderColor: Uti().mainColor,
            ),
            SizedBox(
              height: Dimensions.getHeight(3.0),
            ),
            widget.classList != null
                ? DropDownClassList(
                    mList: widget.classList,
                    hint: 'Class',
                    selectedItem: selectedClass,
                    errorText: _carClassError,
                    onChange: (ClassModel value) {
                      setState(() {
                        selectedClass = value;
                      });
                    })
                : SizedBox(),
            SizedBox(
              height: Dimensions.getHeight(3.0),
            ),
            TextFormBuilder(
              hint: "Number Of Seats",
              keyType: TextInputType.number,
              controller: _seatsNumberController,
              errorText: _seatsNumError,
              activeBorderColor: Uti().mainColor,
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
                color: Uti().mainColor,
                child: Text(
                  widget.editCar == null ? 'Add Car' : 'Edit Car',
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
    );
  }

  void _apiRequest() async {
    String carNumber = _carNumController.text;
    String seatsNumber = _seatsNumberController.text;

    if (carNumber == null || carNumber.isEmpty) {
      setState(() {
        _carNumError = "Please enter car Number";
      });
    } else if (selectedClass == null) {
      clear();
      setState(() {
        _carClassError = "Please choose car class";
      });
    } else if (seatsNumber == null || seatsNumber.isEmpty) {
      clear();
      setState(() {
        _seatsNumError = "Please enter No. of seats";
      });
    } else if (int.parse(seatsNumber) > selectedClass.maxCapacity) {
      clear();
      setState(() {
        _seatsNumError = "Max No. of seats is ${selectedClass.maxCapacity}";
      });
    } else {
      clear();
      //do request
      CarModel newCar = CarModel(
        id: widget.editCar != null ? widget.editCar.id : carNumber,
        seats: int.parse(seatsNumber),
        carClass: selectedClass.id,
      );
      widget.editCar == null
          ? await DatabaseService().addCar(newCar: newCar)
          : await DatabaseService().updateCar(updatedCar: newCar);

      Navigator.pop(context);
    }
  }

  void clear() {
    setState(() {
      _carClassError = "";
      _carClassError = "";
      _carNumError = "";
    });
  }
}
