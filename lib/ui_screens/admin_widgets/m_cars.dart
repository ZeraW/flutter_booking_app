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

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Manage Cars',
            style: TextStyle(
                color: Colors.white,
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
                return CarCard(
                  title: mList[index].carClass,
                  capacity: mList[index].capacity,
                  delete: () async {
                    await DatabaseService().deleteCar(deleteCar: mList[index]);
                  },
                  edit: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEditCarScreen(editCar: mList[index])));
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
        context, MaterialPageRoute(builder: (_) => AddEditCarScreen()));
  }
}
class AddEditCarScreen extends StatefulWidget {
  CarModel editCar;

  AddEditCarScreen({this.editCar});

  @override
  _AddEditCarScreenState createState() => _AddEditCarScreenState();
}
class _AddEditCarScreenState extends State<AddEditCarScreen> {
  TextEditingController _capacityController = new TextEditingController();
  String carClass;
  String _carClassError = "";

  String _capacityError = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editCar != null) {
      _capacityController.text = widget.editCar.capacity.toString();
      carClass = widget.editCar.carClass;
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
                color: Colors.white,
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
            DropDownStringList(
              errorText: _carClassError,
              mList: ['A', 'B'],
              selectedItem: carClass,
              hint: 'Class',
              onChange: (String value) {
                setState(() {
                  carClass = value;
                });
              },
            ),
            SizedBox(
              height: Dimensions.getHeight(3.0),
            ),
            TextFormBuilder(
              hint: "Capacity",
              keyType: TextInputType.number,
              controller: _capacityController,
              errorText: _capacityError,
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
    String carCapacity = _capacityController.text;
    if (carClass == null || carClass.isEmpty) {
      setState(() {
        _carClassError = "Please choose car class";
      });
    } else if (carCapacity == null || carCapacity.isEmpty) {
      clear();
      setState(() {
        _capacityError = "Please enter car capacity";
      });
    } else {
      clear();
      //do request
      CarModel newCar = CarModel(
          id: carClass, carClass: carClass, capacity: int.parse(carCapacity));
      widget.editCar == null
          ? await DatabaseService().addCar(newCar: newCar)
          : await DatabaseService().updateCar(updatedCar: newCar);

      Navigator.pop(context);
    }
  }

  void clear() {
    setState(() {
      _capacityError = "";
      _carClassError = "";
    });
  }
}
