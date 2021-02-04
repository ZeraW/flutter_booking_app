import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id, password, firstName, lastName, phone, logo, type;

  UserModel(
      {this.id,
      this.password,
      this.firstName,
      this.lastName,
      this.phone,
      this.logo,
      this.type});

  UserModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.get('id'),
        password = doc.get('password'),
        firstName = doc.get('firstName'),
        lastName = doc.get('lastName'),
        phone = doc.get('phone'),
        type = doc.get('type'),
        logo = doc.get('logo');

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'],
        firstName = json['firstName'],
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
      'phone': phone,
      'logo': logo,
      'type': type,
    };
  }
}

class Fluff {
  final String sender;
  final DateTime
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final String image;
  final String video;

  Fluff({
    this.sender,
    this.time,
    this.text,
    this.image,
    this.video,
  });

  List<Fluff> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Fluff(
        sender: doc.get('sender') ?? '',
        time: doc.get('time').toDate() ?? '',
        text: doc.get('text'),
        image: doc.get('image'),
        video: doc.get('video'),
      );
    }).toList();
  }

  Fluff.fromJson(Map<String, dynamic> json)
      : sender = json['sender'],
        time = json['time'].toDate(),
        text = json['text'],
        image = json['image'],
        video = json['video'];

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'time': time,
      'text': text,
      'image': image,
      'video': video,
    };
  }
}

class CarModel {
  final String id;
  final String carClass;
  final int capacity;

  CarModel({this.id, this.carClass, this.capacity});

  List<CarModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CarModel(
        id: doc.get('id') ?? '',
        carClass: doc.get('carClass') ?? '',
        capacity: doc.get('capacity') ?? 0,
      );
    }).toList();
  }

  CarModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        carClass = json['carClass'],
        capacity = json['capacity'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['carClass'] = this.carClass;
    data['capacity'] = this.capacity;
    return data;
  }
}

class TrainModel {
   String id;
  final String name;
  final int classAcount;
  final int classBcount;

  TrainModel({this.id, this.name, this.classAcount, this.classBcount});

  List<TrainModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TrainModel(
        id: doc.get('id') ?? '',
        name: doc.get('name') ?? '',
        classAcount: doc.get('classAcount') ?? 0,
        classBcount: doc.get('classBcount') ?? 0,
      );
    }).toList();
  }

  TrainModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        classAcount = json['classAcount'],
        classBcount = json['classBcount'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['classAcount'] = this.classAcount;
    data['classBcount'] = this.classBcount;
    return data;
  }
}
