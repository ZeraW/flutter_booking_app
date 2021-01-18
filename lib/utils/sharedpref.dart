import 'package:flutter_booking_app/models/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {


  Future<void> saveTicket({List<Ticket> list}) async {
    final String encodedData = Ticket.encode(list);
    print(encodedData);

    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("encodedList", "$encodedData");
  }

  Future<void> removeItem() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("encodedList", null);
  }

  Future<List<Ticket>>  getTickets ()async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String encodedData = _pref.getString("encodedList");
    final List<Ticket> decodedData = Ticket.decode(encodedData);
    return decodedData;
  }
}




