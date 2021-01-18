import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/ticket.dart';
import 'package:flutter_booking_app/ui_widget/profile_textfield.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/sharedpref.dart';
import 'package:flutter_booking_app/utils/utils.dart';

class AddNewTicket extends StatefulWidget {
  final Function callback;

  AddNewTicket(this.callback);

  @override
  _AddNewTicketState createState() => _AddNewTicketState();
}

class _AddNewTicketState extends State<AddNewTicket> {
  String name = '', from = '', to = '';
  List<Ticket> ticketList;

  @override
  void initState() {
    super.initState();
    getTicketList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Ticket"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(Dimensions.getWidth(5.0)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextFieldBuilder(
                    title: 'Passanger Name',
                    fillText: name,
                    onChange: (value) {
                      name = value;
                    }),
                SizedBox(
                  height: Dimensions.getHeight(2.0),
                ),
                TextFieldBuilder(
                    title: 'Source Station',
                    fillText: from,
                    onChange: (value) {
                      from = value;
                    }),
                SizedBox(
                  height: Dimensions.getHeight(2.0),
                ),
                TextFieldBuilder(
                    title: 'Destination Station',
                    fillText: to,
                    onChange: (value) {
                      to = value;
                    }),
                SizedBox(
                  height: Dimensions.getHeight(8.0),
                ),
                SizedBox(
                  height: Dimensions.getHeight(7.0),
                  child: RaisedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      checkValidation();
                    },
                    color: MyColors().btnColor,
                    child: Center(
                      child: Text(
                        "Create new ticket",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.getWidth(5.0)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void getTicketList() async {
    ticketList = await SharedPref().getTickets();
  }

  void checkValidation() async {
    if (name == null || name.isEmpty) {
      print('name null');
    } else if (from == null || from.isEmpty) {
      print('from null');
    } else if (to == null || to.isEmpty) {
      print('to null');
    } else {
      print('we we');
      ticketList != null
          ? null
          : ticketList = [
              Ticket(
                  id: 0,
                  name: 'Passanger Name',
                  from: 'Source Station',
                  to: 'Destination Station')
            ];
      ticketList.add(new Ticket(from: from, to: to, name: name,id: ticketList.length));
      await SharedPref().saveTicket(list: ticketList);
      widget.callback();
      Navigator.pop(context);
    }
  }
}
