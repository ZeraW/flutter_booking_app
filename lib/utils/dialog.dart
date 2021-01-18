import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs {
  notifierDialog(
      {@required BuildContext context,
        @required String notification,
        @required Map data}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('title'),
            content: Text(notification),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إغلاق'),
              ),
            ],
          );
        });
  }

  deleteDialog(
      {@required BuildContext context,
        @required String content,
        @required Function onPressed}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('حذف'),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء'),
              ),
              FlatButton(
                onPressed: onPressed,
                child: Text('حذف'),
              )
            ],
          );
        });
  }
}
