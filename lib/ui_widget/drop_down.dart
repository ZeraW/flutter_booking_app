import 'package:flutter/material.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'error_widget.dart';

class DropDownStringList extends StatelessWidget {
  final String selectedItem;
  final List<String> mList;
  final Function onChange;
  final String errorText;

  DropDownStringList(
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
          child: new DropdownButton<String>(
              items: mList.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text('Class $value'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? 'Class $selectedItem'
                    : 'Choose Car Class',
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
