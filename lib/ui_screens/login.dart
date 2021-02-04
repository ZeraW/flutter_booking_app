
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/server/auth.dart';
import 'package:flutter_booking_app/server/auth_manage.dart';
import 'package:flutter_booking_app/ui_screens/register.dart';
import 'package:flutter_booking_app/ui_widget/textfield_widget.dart';
import 'package:flutter_booking_app/utils/dimensions.dart';
import 'package:flutter_booking_app/utils/utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  String type;

  LoginScreen({this.type});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String _phoneError = "";
  String _passwordError = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: Dimensions.getHeight(100),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors().pinkColor,
                  MyColors().accentColor,
                ],
                stops: [0.1, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(4.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: Dimensions.getHeight(10),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getWidth(20.0)),
                    child: Image.asset(
                      "assets/images/otoraty.jpeg",
                      fit: BoxFit.cover,
                      height: Dimensions.getWidth(40.0),
                      width: Dimensions.getWidth(40.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.getHeight(7.0),
                ),
                TextFormBuilder(
                  controller: _phoneController,
                  hint: "Phone Number :",
                  keyType: TextInputType.phone,
                  errorText: _phoneError,
                ),
                SizedBox(
                  height: Dimensions.getHeight(3.0),
                ),
                TextFormBuilder(
                  controller: _passwordController,
                  hint: "Password :",
                  keyType: TextInputType.visiblePassword,
                  isPassword: true,
                  errorText: _passwordError,
                ),
                SizedBox(
                  height: Dimensions.getHeight(4.0),
                ),
                SizedBox(
                  height: Dimensions.getHeight(7.0),
                  child: RaisedButton(
                    onPressed: () {
                      _login(context);
                    },
                    color: Color(0xff373951),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.getWidth(4.0),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ), //Spacer(),
                SizedBox(
                  height: Dimensions.getHeight(4.0),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<AuthManage>(context, listen: false)
                        .toggleWidgets(currentPage: 2, type: widget.type);
                  },
                  child: Center(
                    child: Text(
                      "Create new account",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: Dimensions.getWidth(4.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.getHeight(4.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    String phone =
        _phoneController.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String password = _passwordController.text;
    if (phone != null &&
        phone.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      setState(() {
        _passwordError ='';
        _phoneError ='';
      });
      await AuthService().signInWithEmailAndPassword(
          context: context,
          email: '${_phoneController.text}@${widget.type}.com',
          password: _passwordController.text);
    } else {
      setState(() {
        if(phone == null || phone.isEmpty){
          _phoneError = "Enter a valid phone number.";
          _passwordError ='';
        }else {
          _passwordError = "Enter a valid password.";
          _phoneError ='';
        }
      });
    }
  }
}


