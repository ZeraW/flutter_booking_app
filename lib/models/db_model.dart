import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id, password, firstName, lastName, phone, mail, nationalId, logo, type;

  UserModel(
      {this.id,
      this.password,
      this.firstName,
      this.lastName,
      this.mail,
      this.nationalId,
      this.phone,
      this.logo,
      this.type});

  UserModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.data()['id'],
        password = doc.data()['password'],
        firstName = doc.data()['firstName'],
        lastName = doc.data()['lastName'],
        mail = doc.data()['mail'],
        nationalId = doc.data()['nationalId'],
        phone = doc.data()['phone'],
        type = doc.data()['type'],
        logo = doc.data()['logo'];

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'],
        firstName = json['firstName'],
        mail = json['mail'],
        nationalId = json['nationalId'],
        lastName = json['lastName'],
        phone = json['phone'],
        type = json['type'],
        logo = json['logo'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'mail': mail,
      'nationalId': nationalId,
      'phone': phone,
      'logo': logo,
      'type': type,
    };
  }
}

class CarModel {
  String id;
  final String carClass;
  int seats;

  CarModel({this.id,  this.carClass, this.seats});

  List<CarModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CarModel(
        id: doc.data()['id'] ?? '',
        seats: doc.data()['seats'] ?? 0,
        carClass: doc.data()['carClass'] ?? '',
      );
    }).toList();
  }

  CarModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        seats = json['seats'],
        carClass = json['carClass'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seats'] = this.seats;

    data['carClass'] = this.carClass;
    return data;
  }
}

class ClassModel {
  String id;
  final String className;
  final int maxCapacity, price;

  ClassModel({this.id, this.className, this.maxCapacity, this.price});

  List<ClassModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ClassModel(
        id: doc.data()['id'] ?? '',
        maxCapacity: doc.data()['maxCapacity'] ?? 0,
        price: doc.data()['price'] ?? 0,
        className: doc.data()['className'] ?? '',
      );
    }).toList();
  }

  ClassModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        maxCapacity = json['maxCapacity'],
        price = json['price'],
        className = json['className'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['maxCapacity'] = this.maxCapacity;
    data['price'] = this.price;

    data['className'] = this.className;
    return data;
  }
}

class TrainModel {
  String id;
  final String trainType;
  Map<String, int> carCount;
  Map<String, String> keyWords;

  TrainModel(
      {this.id,  this.trainType, this.keyWords, this.carCount});

  List<TrainModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TrainModel(
          id: doc.data()['id'] ?? '',
          trainType: doc.data()['trainType'] ?? '',
          keyWords: doc.data()['keyWords'] != null
              ? Map<String, String>.from(doc.data()['keyWords'])
              : {},
          carCount: doc.data()['carCount'] != null
              ? Map<String, int>.from(doc.data()['carCount'])
              : {});
    }).toList();
  }

  TrainModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        keyWords = json['keyWords'],
        trainType = json['trainType'],
        carCount = json['carCount'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['keyWords'] = this.keyWords;
    data['trainType'] = this.trainType;
    data['carCount'] = this.carCount;
    return data;
  }
}

class CityModel {
  final int id;
  final String name;

  CityModel({this.id, this.name});

  List<CityModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CityModel(
        id: doc.data()['id'] ?? '',
        name: doc.data()['name'] ?? '',
      );
    }).toList();
  }

  CityModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class TripModel {
  String id;
  final String dateFrom, dateTo, numberOfStops, trainId;
  final int prices, source, destination;
  final List<CityModel> stops;
  final Map<String, String> keyWords;

  TripModel(
      {this.id,
      this.source,
      this.destination,
      this.dateFrom,
      this.keyWords,
      this.numberOfStops,
      this.dateTo,
      this.prices,
      this.stops,
      this.trainId});

  List<TripModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TripModel(
          id: doc.data()['id'] ?? '',
          source: doc.data()['source'] ?? 0,
          destination: doc.data()['destination'] ?? 0,
          dateFrom: doc.data()['dateFrom'] ?? DateTime.now().toString(),
          dateTo: doc.data()['dateTo'] ?? DateTime.now().toString(),
          trainId: doc.data()['trainId'] ?? '',
          numberOfStops: doc.data()['numberOfStops'] ?? 0,
          prices: doc.data()['prices'] ?? 0,
          stops: List.from(doc.data()['stops'])
                  .map((data) => CityModel.fromJson(data))
                  .toList() ??
              [],
          keyWords: Map<String, String>.from(doc.data()['keyWords']));
    }).toList();
  }

  TripModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        source = json['source'],
        destination = json['destination'],
        dateFrom = json['dateFrom'],
        dateTo = json['dateTo'],
        trainId = json['trainId'],
        prices = json['prices'],
        numberOfStops = json['numberOfStops'],
        keyWords = json['keyWords'],
        stops = json['stops'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['destination'] = this.destination;
    data['source'] = this.source;
    data['dateFrom'] = this.dateFrom;
    data['dateTo'] = this.dateTo;
    data['trainId'] = this.trainId;
    data['prices'] = this.prices;
    data['keyWords'] = this.keyWords;
    data['numberOfStops'] = this.numberOfStops;
    data['stops'] = this.stops.map((i) => i.toJson()).toList();

    return data;
  }
}

class SeatModel {
  String id;
  final String one, two, three;
  final String four, five;

  SeatModel({this.id, this.five, this.one, this.three, this.two, this.four});

  List<SeatModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SeatModel(
        id: doc.data()['id'] ?? '',
        five: doc.data()['five'] ?? '',
        one: doc.data()['one'] ?? '',
        two: doc.data()['two'] ?? '',
        four: doc.data()['four'] ?? '',
        three: doc.data()['three'] ?? '',
      );
    }).toList();
  }

  SeatModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        five = json['five'],
        one = json['one'],
        two = json['two'],
        four = json['four'],
        three = json['three'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['five'] = this.five;
    data['one'] = this.one;
    data['two'] = this.two;
    data['four'] = this.four;
    data['three'] = this.three;
    return data;
  }
}

class TicketModel {
  String id;
  String date,
      trainId,
      tripId,
      source,
      destination,
      departAt,
      arriveAt,
      userName,
      userId,
      carClass,
      row,
      car,
      seat;
  int price;

  TicketModel(
      {this.id,
      this.date,
      this.trainId,
      this.source,
      this.tripId,
      this.destination,
      this.departAt,
      this.arriveAt,
      this.car,
      this.row,
      this.userId,
      this.userName,
      this.carClass,
      this.seat,
      this.price});

  List<TicketModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TicketModel(
        id: doc.data()['id'] ?? '',
        date: doc.data()['date'] ?? '',
        trainId: doc.data()['trainId'] ?? '',
        source: doc.data()['source'] ?? '',
        car: doc.data()['car'] ?? '',
        row: doc.data()['row'] ?? '',
        tripId: doc.data()['tripId'] ?? '',
        destination: doc.data()['destination'] ?? '',
        departAt: doc.data()['departAt'] ?? '',
        arriveAt: doc.data()['arriveAt'] ?? '',
        userName: doc.data()['userName'] ?? '',
        userId: doc.data()['userId'] ?? '',
        carClass: doc.data()['carClass'] ?? '',
        seat: doc.data()['seat'] ?? '',
        price: doc.data()['price'] ?? 0,
      );
    }).toList();
  }

  TicketModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = json['date'],
        trainId = json['trainId'],
        source = json['source'],
        destination = json['destination'],
        departAt = json['departAt'],
        car = json['car'],
        row = json['row'],
        tripId = json['tripId'],
        arriveAt = json['arriveAt'],
        userName = json['userName'],
        userId = json['userId'],
        carClass = json['carClass'],
        seat = json['seat'],
        price = json['price'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['trainId'] = this.trainId;
    data['source'] = this.source;
    data['tripId'] = this.tripId;

    data['destination'] = this.destination;
    data['departAt'] = this.departAt;
    data['arriveAt'] = this.arriveAt;

    data['car'] = this.car;
    data['row'] = this.row;

    data['userName'] = this.userName;
    data['userId'] = this.userId;

    data['carClass'] = this.carClass;
    data['seat'] = this.seat;
    data['price'] = this.price;
    return data;
  }
}

class StatsModel {
  final String id;
  Map<String, int> tickets;

  StatsModel({this.id, this.tickets});

  List<StatsModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return StatsModel(
        id: doc.data()['id'] ?? '',
        tickets: doc.data()['tickets'] != null
            ? Map<String, int>.from(doc.data()['tickets'])
            : {},
      );
    }).toList();
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tickets'] = this.tickets;
    return data;
  }
}

