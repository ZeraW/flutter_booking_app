import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';

import 'error_widget.dart';

class TextFormBuilder extends StatelessWidget {
  final String hint;
  final TextInputType keyType;
  final bool isPassword;
  final TextEditingController controller;
  final String errorText;
  final Color activeBorderColor;
  TextFormBuilder({this.hint, this.keyType, this.isPassword, this.controller,this.errorText,this.activeBorderColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          // maxLength: maxLength,
            controller: controller,
            validator: (value) {
              if (value.isEmpty) {
                return "Please Enter a valid text";
              }
              return null;
            },
            enabled: true,
            //controller: _controller,
            maxLines: 1,

            //onChanged: onChange,
            keyboardType: keyType != null ? keyType : TextInputType.text,
            obscureText: isPassword != null ? isPassword : false,
            decoration: InputDecoration(
              labelText: '$hint',
              labelStyle: TextStyle(color: activeBorderColor ??Colors.white, fontSize: Dimensions.getWidth(4.5)),
              hintText: "$hint",
              hintStyle: TextStyle(
                  color: activeBorderColor ??Colors.white, fontSize: Dimensions.getWidth(4.5)),
              contentPadding: new EdgeInsets.symmetric(
                  vertical: Dimensions.getHeight(1.0),
                  horizontal: Dimensions.getWidth(4.0)),
              focusedErrorBorder: new OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
              errorStyle: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w500),
              focusedBorder: new OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: activeBorderColor ??Colors.white),
              ),
              errorBorder: new OutlineInputBorder(
                borderSide:
                BorderSide(width: 1, color: Theme.of(context).accentColor),
              ),
              enabledBorder: new OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: Colors.black54, style: BorderStyle.solid),
              ),
              fillColor: Colors.white,
            )),
        errorText != null ? GetErrorWidget(
            isValid: errorText != "", errorText: errorText) : SizedBox()
      ],
    );
  }

}
