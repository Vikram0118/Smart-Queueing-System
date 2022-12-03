import 'package:qbeacon/fragments/useragreementPage.dart';
import 'package:qbeacon/navigationDrawer/navigationDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AboutPage extends StatelessWidget {
  static const String routeName = '/aboutPage';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar( title: Text("About"),),
        drawer: navigationDrawer(),
        body:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:<Widget> [

            Container(
              padding: EdgeInsets.fromLTRB(15.0,20.0,4.0,4.0),
              child: Text(
                  "QBeacon, 1.1.0",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
                ),
              )
            ),

            Container(
                padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
                child: Text(
                  "Application name and version",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey
                  ),
                )
            ),

            Divider(),

            Container(
                padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
                child: Text(
                  "Contact Information",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey
                  ),
                )
            ),

            Container(
                padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
                child: Text(
                  "Gowthamaan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                  ),
                )
            ),

            Container(
                padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
                child: Text(
                  "Developer",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey
                  ),
                )
            ),

            Container(
                padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
                child: Text(
                  "ravigowthamaan@gmail.com",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.blue[700]
                  ),
                )
            ),

            Divider(),

            Center(
              child: FlatButton(
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute (builder:(context)=>useragreementPage()),);
                },
                child: Text(
                  "END-USER LICENCE AGREEMENT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}