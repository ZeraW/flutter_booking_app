import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/drop_down.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../models/db_model.dart';
import '../../ui_widget/home_widgets/admin_widgets/admin_card.dart';

class ManageCitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<CityModel> mList = Provider.of<List<CityModel>>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: MyColors().pinkColor,
          title: Text(
            'Manage Cities',
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
                return CityCard(
                  title: mList[index].name,
                  delete: () async {
                    await DatabaseService().deleteCity(deleteCity: mList[index]);
                  },
                  edit: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEditCitiescreen(editCity: mList[index])));
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
        context, MaterialPageRoute(builder: (_) => AddEditCitiescreen()));
  }
}
class AddEditCitiescreen extends StatefulWidget {
  CityModel editCity;

  AddEditCitiescreen({this.editCity});

  @override
  _AddEditCitiescreenState createState() => _AddEditCitiescreenState();
}
class _AddEditCitiescreenState extends State<AddEditCitiescreen> {
  TextEditingController _cityNameController = new TextEditingController();

  String _cityNameError = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editCity != null) {
      _cityNameController.text = widget.editCity.name.toString();
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
            widget.editCity == null ? 'Add New City' : 'Edit City',
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
    
            TextFormBuilder(
              hint: "City Name",
              keyType: TextInputType.number,
              controller: _cityNameController,
              errorText: _cityNameError,
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
                  widget.editCity == null ? 'Add City' : 'Edit City',
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
    String cityName = _cityNameController.text;
    if (cityName == null || cityName.isEmpty) {
      clear();
      setState(() {
        _cityNameError = "Please enter City capacity";
      });
    } else {
      clear();
      //do request
      CityModel newCity = CityModel(id: widget.editCity != null? widget.editCity.id:'',name: cityName);
      widget.editCity == null
          ? await DatabaseService().addCity(newCity: newCity)
          : await DatabaseService().updateCity(updatedCity: newCity);

      Navigator.pop(context);
    }
  }

  void clear() {
    setState(() {
      _cityNameError = "";
    });
  }
}
