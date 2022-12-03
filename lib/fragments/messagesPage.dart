import 'package:flutter/services.dart';
import 'package:qbeacon/globalValues.dart';
import 'package:qbeacon/navigationDrawer/navigationDrawer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'chatPage.dart';


class MessagesPage extends StatelessWidget {
  static const String routeName = '/messagesPage';

  @override
  Widget build(BuildContext context) {
    return admin.isHost? HostChatPage(): JoinChatPage();
  }
}




class JoinChatPage extends StatefulWidget {
  @override
  _JoinChatPageState createState() => _JoinChatPageState();
}

class _JoinChatPageState extends State<JoinChatPage> {

  final typing = TextEditingController();
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
          print("dataReceivedSubscription: ${jsonEncode(data)}");
          var content = jsonEncode(data).split(':')[2].replaceAll(new RegExp(r'[^\w\s]+'),'');
          if(content.contains('AnNoUnCeMeNt')){
            content = content.replaceAll('AnNoUnCeMeNt', '');
            joinAnnouncement.add(Messages('R', content));
          }
          else {
            joinChat.add(Messages('R', content));
          }
          setState(() {

          });
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) { _scrollController.jumpTo(_scrollController.position.maxScrollExtent); });

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      drawer:  navigationDrawer(),
      body: Stack(
        children: <Widget>[
         Container(
           padding: EdgeInsets.all(5),
           height: (MediaQuery.of(context).size.height)-100,
           child:  ListView.builder(
             itemCount: joinChat.length,
             controller: _scrollController,
             shrinkWrap: true,
             padding: EdgeInsets.only(top: 10,bottom: 10),
             itemBuilder: (context, index){
               return Container(
                 padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                 child: Align(
                   alignment: (joinChat[index].messageType == "R"?Alignment.topLeft:Alignment.topRight),
                   child: Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       color: (joinChat[index].messageType  == "R"?Colors.grey.shade200:Colors.blue[200]),
                     ),
                     padding: EdgeInsets.all(16),
                     child: Text(joinChat[index].message, style: TextStyle(fontSize: 18),),
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
                    child: Icon(Icons.chat, color: Colors.white, size: 20, ),
                  ),

                  SizedBox(width: 15,),

                  Expanded(
                    child: TextFormField(
                      controller: typing,
                      style: TextStyle(color: Colors.black,),
                      decoration: InputDecoration(
                          hintText: "Type your order",
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
                      nearbyService.sendMessage(devices[0].deviceId, 'QAZ' + admin.username);
                      Future.delayed(Duration(seconds: 1),(){
                        nearbyService.sendMessage(devices[0].deviceId, typing.text);
                        joinChat.add(Messages('S', typing.text));
                        setState(() {
                          typing.clear();
                        });
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





class HostChatPage extends StatefulWidget {
  @override
  _HostChatPageState createState() => _HostChatPageState();
}

class _HostChatPageState extends State<HostChatPage> {

  String username =' ', content, peerId;
  List<Messages> temp = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
          print("dataReceivedSubscription: ${jsonEncode(data)}");
          content = jsonEncode(data).split(':')[2].replaceAll(new RegExp(r'[^\w\s]+'),'');
          peerId = jsonEncode(data).split(':')[1].split(',')[0].replaceAll(new RegExp(r'[^\w\s]+'),'');
          print('Data Received');
          if(content.contains('QAZ')){
            username = content.substring(3);
            print(username);
          }
         else{
          temp.clear();
          if(receivedOrders.length == 0){
            temp.add(new Messages('R', content));
            print('First Message + $username ----- $content');
            receivedOrders.add(new Chats(peerId,username, temp));
          }
          else{
            bool isThere = false;
            int index = -1;
            receivedOrders.forEach((element) {
              if(element.deviceId == peerId){
                isThere = true;
                index = receivedOrders.indexOf(element);
              }
            });
            if(isThere && receivedOrders[index].deviceId == peerId){
              print('Already There, $username ------ $content');
              receivedOrders[index].username = username;
              receivedOrders[index].messages.add(new Messages('R', content));
            }
            else{
              temp.clear();
              temp.add(new Messages('R', content));
              receivedOrders.add(new Chats(peerId,username, temp));
            }
          }
          setState(() {});
         }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Received Orders"),
        ),
        drawer:  navigationDrawer(),
        body: ListView.builder(
          itemCount: receivedOrders.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10,bottom: 10),
          itemBuilder: (context, index){
            return GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(child: Icon(Icons.account_circle, color: Colors.grey,), radius: 20,),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(receivedOrders[index].username),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        // Request connect
                      ],
                    ),

                    SizedBox(height: 8.0,),

                    Divider(height: 1, color: Colors.grey,)
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ChatPage(receivedOrders[index]);
                }));
              },
            );
          },
        ),
    );
  }
}