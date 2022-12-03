import 'package:flutter/material.dart';

Widget createDrawerBodyItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Text("          "),
        Padding(
          padding: EdgeInsets.all(0.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}