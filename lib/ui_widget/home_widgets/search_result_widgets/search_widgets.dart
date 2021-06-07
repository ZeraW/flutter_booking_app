import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';

class UserTripsCard extends StatelessWidget {
  final String dateFrom, dateTo;
  final String source;
  final String destination;

  final Function onTap;

  UserTripsCard(
      {this.dateFrom, this.dateTo, this.source, this.destination, this.onTap});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    DateFormat timeFormat = DateFormat("HH:mm");

    String depart = timeFormat.format(dateFormat.parse(dateFrom));
    String arrive = timeFormat.format(dateFormat.parse(dateTo));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.getWidth(8),
              vertical: Dimensions.getHeight(1)),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: TextWithDot(
                      dotColor: Colors.green,
                      text: source,
                      fontSize: 5,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Image.asset(
                      'assets/images/train.png',
                      height: Dimensions.getWidth(8),
                      width: Dimensions.getWidth(8),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextWithDot(
                          dotColor: Colors.red,
                          text: destination,
                          fontSize: 5,
                          leading: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('Departure'),
                        SizedBox(
                          height: 5,
                        ),
                        Text(depart)
                      ],
                    ),
                    Spacer(),
                    Text(
                        '___ ${durationToString(dateFormat.parse(dateTo).difference(dateFormat.parse(dateFrom)).inMinutes)} ___      '),
                    Spacer(),
                    Column(
                      children: [
                        Text('Arrival'),
                        SizedBox(
                          height: 5,
                        ),
                        Text(arrive)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}h:${parts[1].padLeft(2, '0')}m';
  }
}

class UserMoneyTripsCard extends StatelessWidget {
  final String dateFrom, dateTo;
  final String source;
  final String destination;
  final String price,stops,type;

  final Function onTap;
  final Function onCancel;

  UserMoneyTripsCard(
      {this.dateFrom, this.dateTo, this.source,this.price,this.type,this.stops, this.destination, this.onTap,this.onCancel});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("HH:mm");
    DateFormat timeFormat = DateFormat("HH:mm");

    String depart = timeFormat.format(dateFormat.parse(dateFrom));
    String arrive = timeFormat.format(dateFormat.parse(dateTo));

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: Dimensions.getHeight(6),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Uti().pinkColor.withOpacity(0.99),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                      ),
                    ]),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:  EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Text('$stops',style: TextStyle(fontWeight: FontWeight.w600),),
                      Spacer(),
                      Text(price!=null ?'Price : ${price}':'${type}',style: TextStyle(fontWeight: FontWeight.w600),),
                      price==null&& type.isEmpty ?Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: RaisedButton(onPressed: onCancel,child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),color: Colors.redAccent,disabledColor: Colors.redAccent,),
                      ):SizedBox()

                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTap,

              child: Container(
                margin: EdgeInsets.only(bottom: Dimensions.getHeight(5)),

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                      ),
                    ]),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.getWidth(8),
                      vertical: Dimensions.getHeight(1)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: TextWithDot(
                              dotColor: Colors.green,
                              text: source,
                              fontSize: 4.5,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Image.asset(
                              'assets/images/train.png',
                              height: Dimensions.getWidth(8),
                              width: Dimensions.getWidth(8),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextWithDot(
                                  dotColor: Colors.red,
                                  text: destination,
                                  fontSize: 4.5,
                                  leading: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text('Departure'),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(depart)
                              ],
                            ),
                            Spacer(),
                            Text(
                                '___ ${durationToString(dateFormat.parse(dateTo).difference(dateFormat.parse(dateFrom)).inMinutes)} ___      '),
                            Spacer(),
                            Column(
                              children: [
                                Text('Arrival'),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(arrive)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
        SizedBox(height: Dimensions.getHeight(2),)
      ],
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}h:${parts[1].padLeft(2, '0')}m';
  }
}

class TextWithDot extends StatelessWidget {
  final Color dotColor;
  final String text;
  final double fontSize;
  final bool leading;

  TextWithDot(
      {this.dotColor, this.text, this.fontSize = 4, this.leading = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading
            ? CircleAvatar(
                radius: 5,
                backgroundColor: dotColor,
              )
            : SizedBox(),
        SizedBox(
          width: Dimensions.getWidth(leading ? 2.5 : 0),
        ),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: Dimensions.getWidth(fontSize)),
        ),
        SizedBox(
          width: Dimensions.getWidth(!leading ? 2.5 : 0),
        ),
        !leading
            ? CircleAvatar(
                radius: 5,
                backgroundColor: dotColor,
              )
            : SizedBox(),
      ],
    );
  }
}

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final String text;
  final Function onTap;

  RoundedContainer({this.child, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: Dimensions.getWidth(2)),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            width: Dimensions.getWidth(38),
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.getWidth(2),
                horizontal: Dimensions.getWidth(3)),
            child: child,
          ),
        ),
      ],
    );
  }
}


class ReservationCard extends StatelessWidget {
  final String dateFrom, dateTo;
  final String source;
  final String destination;
  final String price,stops,type;
  final TicketModel ticket;
  final Function onTap;
  final Function onCancel;

  ReservationCard(
      {this.dateFrom, this.dateTo, this.source,this.price,this.ticket,this.type,this.stops, this.destination, this.onTap,this.onCancel});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("HH:mm");
    DateFormat timeFormat = DateFormat("HH:mm");

    String depart = timeFormat.format(dateFormat.parse(dateFrom));
    String arrive = timeFormat.format(dateFormat.parse(dateTo));

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: Dimensions.getHeight(6),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Uti().pinkColor.withOpacity(0.99),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                      ),
                    ]),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:  EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Text('$stops',style: TextStyle(fontWeight: FontWeight.w600),),
                      Spacer(),
                      Text(price!=null ?'Price : ${price}':'${type}',style: TextStyle(fontWeight: FontWeight.w600),),
                      price==null&& type.isEmpty ?Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: RaisedButton(onPressed: onCancel,child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),color: Colors.redAccent,disabledColor: Colors.redAccent,),
                      ):SizedBox()
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTap,

              child: Container(
                margin: EdgeInsets.only(bottom: Dimensions.getHeight(5)),

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                      ),
                    ]),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.getWidth(8),
                      vertical: Dimensions.getHeight(1)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'from: $source',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: Dimensions.getWidth(4)),
                          ),
                          Spacer(),
                          Text(
                            'to: $destination',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: Dimensions.getWidth(4)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            'depart: $depart',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: Dimensions.getWidth(4)),
                          ),
                          Spacer(),
                          Text(
                            'arrive: $arrive',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: Dimensions.getWidth(4)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'user: ${ticket.userName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: Dimensions.getWidth(4)),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
        SizedBox(height: Dimensions.getHeight(2),)
      ],
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}h:${parts[1].padLeft(2, '0')}m';
  }
}