import 'package:qbeacon/navigationDrawer/navigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qbeacon/globalValues.dart';


class AnnouncementPage extends StatelessWidget {
  static const String routeName = '/announcementPage';

  @override
  Widget build(BuildContext context) {
    return admin.isHost? HostAnnouncement(): JoinAnnouncement();
  }
}



class JoinAnnouncement extends StatefulWidget {
  @override
  _JoinAnnouncementState createState() => _JoinAnnouncementState();
}

class _JoinAnnouncementState extends State<JoinAnnouncement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Announcements"),
        ),
        drawer:  navigationDrawer(),
        body: Container(
          height: (MediaQuery.of(context).size.height)-80,
          child:  ListView.builder(
            itemCount: joinChat.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            itemBuilder: (context, index){
              print('${joinAnnouncement[index].message}');
              return Container(
                padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (joinAnnouncement[index].messageType == "R"?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (joinAnnouncement[index].messageType  == "R"?Colors.grey.shade200:Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(joinAnnouncement[index].message, style: TextStyle(fontSize: 18),),
                  ),
                ),
              );
            },
          ),
        )
    );
  }
}



class HostAnnouncement extends StatefulWidget {
  @override
  _HostAnnouncementState createState() => _HostAnnouncementState();
}

class _HostAnnouncementState extends State<HostAnnouncement> {

  final typing = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Announcements"),
        ),
        drawer:  navigationDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height)-100,
            child:  ListView.builder(
              itemCount: joinAnnouncement.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10,bottom: 10),
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                  child: Align(
                    alignment: (joinAnnouncement[index].messageType == "R"?Alignment.topLeft:Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (joinAnnouncement[index].messageType  == "R"?Colors.grey.shade200:Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(joinAnnouncement[index].message, style: TextStyle(fontSize: 15),),
                    ),
                  ),
                );
              },
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[

                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.announcement_rounded, color: Colors.white, size: 20, ),
                  ),

                  SizedBox(width: 15,),

                  Expanded(
                    child: TextFormField(
                      controller: typing,
                      style: TextStyle(color: Colors.black,),
                      decoration: InputDecoration(
                          hintText: "Type the Announcement",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                      obscureText: false,
                      cursorColor: Colors.white,
                      onSaved: (text) {
                        setState(() {
                          typing.text = text;
                        });
                        SystemChrome.restoreSystemUIOverlays();
                      },
                      onChanged: (text) {
                        setState(() {
                          SystemChrome.restoreSystemUIOverlays();
                        });
                      },
                    ),
                  ),

                  SizedBox(width: 15,),

                  FloatingActionButton(
                    onPressed: (){
                      connectedDevices.forEach((element) {
                        nearbyService.sendMessage(element.deviceId, typing.text + 'AnNoUnCeMeNt');
                      });
                      joinAnnouncement.add(Messages('S', typing.text));
                      setState(() {
                        typing.clear();
                      });
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],

              ),
            ),
          ),
        ],
      ),
    );
  }
}

