import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';

class TextFieldBuilder extends StatelessWidget {
  String title, fillText;
  TextEditingController _controller;
  int maxLength, height;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool noSpace, enabled;
  final ValueChanged<String> onChange;

  TextFieldBuilder(
      {@required this.title,
      this.fillText,
      this.isPassword,
      this.enabled,
      this.maxLength,
      this.keyboardType,
      this.noSpace,
      this.height = 1,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    _controller = new TextEditingController(text: fillText);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: Dimensions.getHeight(0.5),
          ),
          TextFormField(
              maxLength: maxLength,
              validator: (value) {
                if (value.isEmpty) {
                  return 'الرجاء إدخال نص';
                }
                return null;
              },
              enabled: enabled,
              controller: _controller,
              maxLines: height,
              onChanged: onChange,
              keyboardType:
                  keyboardType != null ? keyboardType : TextInputType.text,
              obscureText: isPassword != null ? isPassword : false,
              decoration: InputDecoration(
                  focusedErrorBorder: new OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Theme.of(context).accentColor),
                  ),
                  errorStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w500),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:  BorderSide(width: 1.8,color:  MyColors().btnColor),

                  ),
                  errorBorder: new OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Theme.of(context).accentColor),
                  ),
                  disabledBorder: new OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: MyColors().btnColor,
                        style: BorderStyle.solid),
                  ),
                  enabledBorder: new OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: MyColors().btnColor,
                        style: BorderStyle.solid),
                  ),
                  fillColor: Colors.white,
                  filled: true)),
        ],
      ),
    );
  }
}
