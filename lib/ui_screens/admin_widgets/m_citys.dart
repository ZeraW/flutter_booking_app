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
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Manage Stations',
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
                return CityCard(
                  title: '${mList[index].id}.${mList[index].name}',
                  edit: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEditCitiescreen(editCity: mList[index])));
                  },delete: () async {
                  await DatabaseService().deleteCity(deleteCity: mList[index]);
                }
                );
              },
              itemCount: mList.length,
            )
          : SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _increment(context: context,nextId: mList!=null ? mList.length+1:0),
        tooltip: 'Increment',
        backgroundColor: Uti().mainColor.withOpacity(0.9),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _increment({BuildContext context,int nextId}) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => AddEditCitiescreen(nextId: nextId.toString(),)));
  }
}
class AddEditCitiescreen extends StatefulWidget {
  CityModel editCity;
  String nextId;
  AddEditCitiescreen({this.editCity,this.nextId});

  @override
  _AddEditCitiescreenState createState() => _AddEditCitiescreenState();
}
class _AddEditCitiescreenState extends State<AddEditCitiescreen> {
  TextEditingController _idController = new TextEditingController();
  TextEditingController _cityNameController = new TextEditingController();

  String _cityNameError = "";
  String _idError = "";

  @override
  void initState() {

    super.initState();
    if (widget.editCity != null) {
      _cityNameController.text = widget.editCity.name.toString();
      _idController.text = widget.editCity.id.toString();

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
            widget.editCity == null ? 'Add New Station' : 'Edit Station',
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
              hint: "Station ID",
              keyType: TextInputType.number,
              controller: _idController,
              enabled: widget.editCity==null,
              errorText: _idError,
              activeBorderColor: Uti().mainColor,

            ),
            SizedBox(
              height: Dimensions.getHeight(3.0),
            ),
    
            TextFormBuilder(
              hint: "Station Name",
              keyType: TextInputType.text,
              controller: _cityNameController,
              errorText: _cityNameError,
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
                  widget.editCity == null ? 'Add Station' : 'Edit Station',
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
    String cityId = _idController.text;

    if (cityId == null || cityId.isEmpty) {
      clear();
      setState(() {
        _idError = "Please enter Station ID";
      });
    }else if (cityName == null || cityName.isEmpty) {
      clear();
      setState(() {
        _cityNameError = "Please enter Station Name";
      });
    } else {
      clear();
      //do request
      CityModel newCity = CityModel(id:int.parse(cityId),name: cityName);
      widget.editCity == null
          ? await DatabaseService().addCity(newCity: newCity)
          : await DatabaseService().updateCity(updatedCity: newCity);

      Navigator.pop(context);
    }
  }

  void clear() {
    setState(() {
      _cityNameError = "";
      _idError = "";

    });
  }
}
