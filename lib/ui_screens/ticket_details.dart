import 'dart:io';
import 'dart:typed_data';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/ui_widget/widget_to_png.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class TicketDetails extends StatefulWidget {
  TicketModel ticket;

  TicketDetails(this.ticket);

  @override
  _TicketDetailsState createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  GlobalKey key1;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateFormat("yyyy-MM-dd").parse(widget.ticket.date);
    String dateFormat = DateFormat('yMMMMd').format(date);
    List<ClassModel> classList = Provider.of<List<ClassModel>>(context);
    List<CityModel> cityList = Provider.of<List<CityModel>>(context);
    List<TrainModel> trainList = Provider.of<List<TrainModel>>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Ticket',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: classList != null && cityList != null && trainList != null
          ? ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: WidgetToImage(builder: (key) {
                    this.key1 = key;
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/trlogo.png',
                            height: Dimensions.getWidth(50),
                            width: Dimensions.getWidth(50),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            decoration: BoxDecoration(
                                color: Uti().mainColor,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  Text(
                                    '${DateFormat('EEEE').format(date)}, ${dateFormat}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Train ${widget.ticket.trainId}',
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${trainList.firstWhere((element) => element.id == widget.ticket.trainId).trainType}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        cityList
                                            .firstWhere((element) =>
                                                element.id.toString() ==
                                                widget.ticket.source)
                                            .name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        '. . . . . . . .',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        cityList
                                            .firstWhere((element) =>
                                                element.id.toString() ==
                                                widget.ticket.destination)
                                            .name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Departure',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Arrival',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.ticket.departAt}',
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${widget.ticket.arriveAt}',
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1.5,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Passenger',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.ticket.userName}',
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Class',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Seat',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${classList.firstWhere((element) => element.id == widget.ticket.carClass).className}',
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${widget.ticket.car.substring(widget.ticket.car.length - 2)}/${widget.ticket.row}/${widget.ticket.seat}',
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Uti().pinkColor,
                                        borderRadius: BorderRadius.circular(11)),
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text('Booking ID : ${widget.ticket.id}'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Price : ${widget.ticket.price}'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: Uti.materialColor(Uti().mainColor)),
                      onPressed: () async {
                        final bytes1 = await Utils.capture(key1);
                        if (await Permission.storage.request().isGranted) {
                          String path = await createFolder('Otoraty');
                          await File('$path/${widget.ticket.id}.png').writeAsBytes(bytes1);
                        } else {
                          await [
                            Permission.storage,
                          ].request().then((value) async{
                            if (await Permission.storage.request().isGranted){
                              String path = await createFolder('Otoraty');
                              await File('$path/${widget.ticket.id}.png').writeAsBytes(bytes1);
                            }
                          });
                        }

                      },
                      child: Text('Download Ticket',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,letterSpacing: 1.2),),
                    ),
                  ),
                )
              ],
            )
          : SizedBox(),
    );
  }


  Future<String> createFolder(String cow) async {
    final folderName = cow;
    final path = Directory("storage/emulated/0/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }
}
