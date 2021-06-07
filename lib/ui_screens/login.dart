
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
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String _emailError = "";
  String _passwordError = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Uti().pinkColor,
                Uti().accentColor,
              ],
              stops: [0.1, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.isPortrait() ? Dimensions.getWidth(6.0) : Dimensions.getWidth(100.0)),
          child: ListView(
            children: [
              SizedBox(
                height: Dimensions.getHeight(6),
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
                height: Dimensions.getHeight(12.0),
              ),
              TextFormBuilder(
                controller: _mailController,
                hint: "Email :",
                keyType: TextInputType.emailAddress,
                errorText: _emailError,
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
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor:MaterialStateColor.resolveWith((states) => Color(0xff373951))),
                  onPressed: () {
                    _login(context);
                  },
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

            ],
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    String email =
        _mailController.text;
    String password = _passwordController.text;
    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      setState(() {
        _passwordError ='';
        _emailError ='';
      });
      await AuthService().signInWithEmailAndPassword(
          context: context,
          email: '${_mailController.text}.${widget.type}',
          password: _passwordController.text);
    } else {
      setState(() {
        if(email == null || email.isEmpty){
          _emailError = "Enter a valid email";
          _passwordError ='';
        }else {
          _passwordError = "Enter a valid password.";
          _emailError ='';
        }
      });
    }
  }
}


