import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';
import 'package:toast/toast.dart';
import 'database_api.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  UserModel _userFromFirebaseUser(User user) {return user != null ? UserModel(id: user.uid) : null;}

  // auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // sign in with email and password
  Future signInWithEmailAndPassword({BuildContext context, String email, String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Toast.show("No user found for that phone number.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      } else if (e.code == 'wrong-password') {
        Toast.show("Wrong password provided for that user.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword({BuildContext context,UserModel newUser,File userImage}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: '${newUser.phone}@${newUser.type}.com', password: newUser.password);
      print('XDA : ' + result.user.uid);

      User fbUser = result.user;
      newUser.id = fbUser.uid;

      newUser.logo =await DatabaseService().uploadImageToStorage(userId:fbUser.uid,file: userImage);

       await DatabaseService().updateUserData(user: newUser);

      return _userFromFirebaseUser(fbUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Toast.show("The password provided is too weak.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Toast.show("The account already exists for that email.", context,
            backgroundColor: Colors.redAccent,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }
    } catch (e) {
      print(e);
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
