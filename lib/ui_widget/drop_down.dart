import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'error_widget.dart';

class DropDownStringList extends StatelessWidget {
  final List<String> mList;
  final Function onChange;
  final String errorText,hint,selectedItem;

  DropDownStringList(
      {this.selectedItem, this.mList,this.hint, this.onChange, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4),
          ),
          child: new DropdownButton<String>(
              items: mList.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text('$hint: $value'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? '$hint: $selectedItem'
                    : 'Choose $hint',
                style: TextStyle(
                    color:  MyColors().mainColor,fontSize: Dimensions.getWidth(4)),
              ),
              onChanged: onChange),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}


class DropDownCityList extends StatelessWidget {
  final CityModel selectedItem;
  final List<CityModel> mList;
  final Function onChange;
  final String hint;
  final String errorText;

  DropDownCityList(
      {this.selectedItem, this.mList,this.hint, this.onChange, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4),
          ),
          child: new DropdownButton<CityModel>(
              items: mList.map((CityModel value) {
                return new DropdownMenuItem<CityModel>(
                  value: value,
                  child: new Text('${value.name}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? '$hint: ${selectedItem.name}'
                    : 'Choose $hint',
                style: TextStyle(
                    color:  MyColors().mainColor,fontSize: Dimensions.getWidth(4)),
              ),
              onChanged: onChange),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}

class DropDownTrainList extends StatelessWidget {
  final TrainModel selectedItem;
  final List<TrainModel> mList;
  final Function onChange;
  final String errorText;

  DropDownTrainList(
      {this.selectedItem, this.mList, this.onChange, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4),
          ),
          child: new DropdownButton<TrainModel>(
              items: mList.map((TrainModel value) {
                return new DropdownMenuItem<TrainModel>(
                  value: value,
                  child: new Text('${value.name}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? 'Train: ${selectedItem.name}'
                    : 'Choose Train',
                style: TextStyle(
                    color:  MyColors().mainColor,fontSize: Dimensions.getWidth(4)),
              ),
              onChanged: onChange),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}
