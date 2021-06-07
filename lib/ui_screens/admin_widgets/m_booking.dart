import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:flutter_booking_app/server/database_api.dart';
import 'package:flutter_booking_app/ui_widget/drop_down.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/admin_widgets/admin_card.dart';
import 'package:flutter_booking_app/ui_widget/home_widgets/search_result_widgets/search_widgets.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';


class ManageBookingsScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<TrainModel> mTrainList = Provider.of<List<TrainModel>>(context);
    List<TripModel> mTripList = Provider.of<List<TripModel>>(context);

    if(mTripList!=null)mTripList.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));



    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Manage Reservation',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: mTripList != null
          ? ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.getWidth(2),
            vertical: Dimensions.getHeight(1.5)),
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          TripModel trip = mTripList[index];
          return TripResCard(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TicketByDayAndClass()));
            },
            tripNum: trip.id.toString(),
            destination: mCityList.firstWhere((element) => element.id == trip.destination).name,
            source: mCityList.firstWhere((element) => element.id == trip.source).name,
          );
        },
        itemCount: mTripList.length,
      )
          : SizedBox(),
      );
  }


}




class TicketByDayAndClass extends StatefulWidget {

  @override
  _TicketByDayAndClassState createState() => _TicketByDayAndClassState();
}

class _TicketByDayAndClassState extends State<TicketByDayAndClass> {
  String date = DateTime.now().toString().substring(0, 10);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Uti().pinkColor,
          title: Text(
            'Tickets',
            style: TextStyle(
                color: Uti().mainColor,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getWidth(5)),
          )),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select Date : ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,),),
              GestureDetector(
                onTap: _selectDate,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [Text(date,style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.w400,fontSize: 20,color: Colors.blueAccent),),SizedBox(width: 6,), Icon(Icons.timer)]),
                ),
              ),
            ],
          ),
          Expanded(
            child:MultiProvider(providers: [
              StreamProvider<List<CityModel>>.value(
                  value: DatabaseService().getLiveCities),
              StreamProvider<List<ClassModel>>.value(
                  value: DatabaseService().getLiveClass),
              StreamProvider<List<TicketModel>>.value(
                  value: DatabaseService().ticketsByDay(date)),
            ], child: ListOfTicket()),
          )
        ],
      ),
    );
  }


  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        date = picked.toString().substring(0, 10);
        print(date);
      });
  }
}


class ListOfTicket extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<TicketModel> mTripList = Provider.of<List<TicketModel>>(context);
    List<ClassModel> mClassList = Provider.of<List<ClassModel>>(context);

    return mTripList!=null?ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.getWidth(5),
          vertical: Dimensions.getHeight(1.5)),
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        String source = mCityList
            .firstWhere((element) =>
        element.id.toString() == mTripList[index].source)
            .name;
        String destination = mCityList
            .firstWhere((element) =>
        element.id.toString() == mTripList[index].destination)
            .name;

        String className = mClassList
            .firstWhere((element) =>
        element.id.toString() == mTripList[index].carClass)
            .className;
        return ReservationCard(
          dateFrom: mTripList[index].departAt.toString(),
          dateTo: mTripList[index].arriveAt.toString(),
          destination: destination,
          source: source,
          ticket: mTripList[index],
          type: '',
          onCancel: ()async{
            await DatabaseService().deleteSeat(ticket: mTripList[index]);
          },
          stops: 'Class : ${className}',
          onTap: () async {},
        );
      },
      itemCount: mTripList.length,
    ):Text('No Booked Ticket');
  }
}




