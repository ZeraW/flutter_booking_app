import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/drop_down.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/admin_widgets/admin_card.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class ManageClassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ClassModel> mList = Provider.of<List<ClassModel>>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Manage Class',
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
                return ClassCard(
                  title: mList[index].className,
                  delete: () async {
                    await DatabaseService().deleteClass(deleteClass: mList[index]);
                  },
                  edit: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEditClassScreen(editClass: mList[index])));
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
        context, MaterialPageRoute(builder: (_) => AddEditClassScreen()));
  }
}

class AddEditClassScreen extends StatefulWidget {
  ClassModel editClass;

  AddEditClassScreen({this.editClass});

  @override
  _AddEditClassScreenState createState() => _AddEditClassScreenState();
}
class _AddEditClassScreenState extends State<AddEditClassScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _capacityController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();

  String _nameError = "";
  String _capacityError = "";
  String _priceError = "";

  @override
  void initState() {

    super.initState();
    if (widget.editClass != null) {
      _nameController.text = widget.editClass.className.toString();
      _capacityController.text = widget.editClass.maxCapacity.toString();
      _priceController.text = widget.editClass.price.toString();

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
            widget.editClass == null ? 'Add New Class' : 'Edit Class',
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
              hint: "Class Name",
              keyType: TextInputType.name,
              controller: _nameController,
              errorText: _nameError,
              activeBorderColor: Uti().mainColor,

            ),
            SizedBox(
              height: Dimensions.getHeight(3.0),
            ),
            TextFormBuilder(
              hint: "Max Number Of Seats",
              keyType: TextInputType.number,
              controller: _capacityController,
              errorText: _capacityError,
              activeBorderColor: Uti().mainColor,

            ),
            SizedBox(
              height: Dimensions.getHeight(3.0),
            ),
            TextFormBuilder(
              hint: "Class Price",
              keyType: TextInputType.number,
              controller: _priceController,
              errorText: _priceError,
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
                  widget.editClass == null ? 'Add Class' : 'Edit Class',
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
    String carName = _nameController.text;
    String capacity = _capacityController.text;
    String price = _priceController.text;

    if (carName == null || carName.isEmpty) {
      clear();
      setState(() {
        _nameError = "Please enter class name";
      });
    }else if (capacity == null || capacity.isEmpty) {
      clear();
      setState(() {
        _capacityError = "Please enter Seats number";
      });
    }else if (price == null || price.isEmpty) {
      clear();
      setState(() {
        _capacityError = "Please enter Class Price";
      });
    } else {
      clear();
      //do request
      ClassModel newClass = ClassModel(
          id: widget.editClass != null? widget.editClass.id:'', className: carName,maxCapacity: int.parse(capacity),price: int.parse(price));
      widget.editClass == null
          ? await DatabaseService().addClass(newClass: newClass)
          : await DatabaseService().updateClass(updatedClass: newClass);

      Navigator.pop(context);
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
      _capacityError = "";
      _priceError = "";

    });
  }
}
