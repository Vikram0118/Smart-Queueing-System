import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:qbeacon/qbeacon_search/search.dart';
import 'package:qbeacon/splash_screen/login/ui_constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'fade_slide_transition.dart';
import 'package:qbeacon/globalValues.dart';
import 'package:qbeacon/fragments/all.dart';


class LoginForm extends StatefulWidget {
  final Animation<double> animation;

  LoginForm({
    @required this.animation,
  }) : assert(animation != null);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  var username = TextEditingController();
  int _radioValue1 = -1;
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    var space = height > 650 ? kSpaceM : kSpaceS;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        children: <Widget>[

          FadeSlideTransition(
            animation: widget.animation,
            additionalOffset: 0.0,
            child: TextFormField(
              controller: username,
              style: TextStyle(color: Colors.white,),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(kPaddingM),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),),
                focusColor: Colors.white,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),),
                hintText: "Username",
                hintStyle: TextStyle(fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(1)),
                prefixIcon: Icon(Icons.account_circle_outlined,
                  color: Colors.white.withOpacity(1),),
              ),
              obscureText: false,
              cursorColor: Colors.white,
              onSaved: (text) {
                setState(() {
                  username.text = text;
                });
                SystemChrome.restoreSystemUIOverlays();
              },
              onChanged: (text) {
                setState(() {
                  admin.username = username.text;
                  SystemChrome.restoreSystemUIOverlays();
                });
              },
            ),
          ),

          SizedBox(height: space),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: _radioValue1,
                activeColor: Colors.lightBlue,
                onChanged: (i) {
                  setState(() {
                    _radioValue1 = 0;
                    admin.isHost = true;
                  });
                },
              ),
              new Text('QB Host',
                style: new TextStyle(fontSize: 16.0, color: kWhite),),
              SizedBox(width: 4 * space),
              new Radio(
                value: 1,
                groupValue: _radioValue1,
                onChanged: (i) {
                  setState(() {
                    _radioValue1 = 1;
                    admin.isHost = false;
                  });
                },
                activeColor: Colors.lightBlue,
              ),
              new Text('Join QB',
                style: new TextStyle(fontSize: 16.0, color: kWhite),),
            ],
          ),

          SizedBox(height: space),

          FadeSlideTransition(
            animation: widget.animation,
            additionalOffset: 2 * space,
            child: RoundedLoadingButton(
              child: Text(
                "Get Started",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold,),
              ),
              color: Colors.indigo[600],
              successColor: Colors.green,
              controller: _btnController,
                onPressed: () {
                  switch(_radioValue1) {
                    case 0:{
                      _btnController.success();
                      Fluttertoast.showToast(msg: "Please wait");
                      Future.delayed(Duration(seconds: 2),(){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DealsPage()));
                      });
                    }
                    break;

                    case 1:{
                      _btnController.success();
                      Fluttertoast.showToast(msg: "Please wait");
                      Future.delayed(Duration(seconds: 2),(){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QBeaconSearch()));
                      });
                    }
                    break;

                    default:{
                      _btnController.reset();
                      showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                            title: new Text("Oops!!!"),
                            content: new Text("Enter a valid username and Select your QBeacon service"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Close me!', style: TextStyle(color: Colors.red),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                    }
                    break;
                  }
                },
            ),
          ),

          SizedBox(height: 8 * space),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Copyright ",
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              Icon(
                Icons.copyright,
                size: 16,
                color: Colors.grey[500],
              ),
              Text(
                " 2021 Equinox Group",
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

