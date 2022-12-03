import 'package:flutter/material.dart';

// ignore: camel_case_types
class useragreementPage extends StatelessWidget {
  static const String routeName = '/Page';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("End-User License Agreement"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Container(
                padding: EdgeInsets.fromLTRB(15.0,20.0,4.0,4.0),
                child: Text(
                  "QBeacon, 1.1.0",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
                child:Row(
                  children:<Widget> [
                    Text("Copyright "),
                    Icon(Icons.copyright, size: 16),
                    Text(" 2021 Gowthamaan")
                  ],
                ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15.0,4.0,12.0,4.0),
                child: Text(
                  "QBeacon is developed by Gowthamaan for providing social distance monitoring and proximity marketing services.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                )
            )
          ],
        )
    );
  }
}