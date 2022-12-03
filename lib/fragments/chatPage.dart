import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbeacon/globalValues.dart';

class ChatPage extends StatefulWidget {
  final Chats peer;
  ChatPage(this.peer);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final typing = TextEditingController();
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
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
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.black,), ),
                SizedBox(width: 2,),
                CircleAvatar(child: Icon(Icons.account_circle, color: Colors.grey,), maxRadius: 20,),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${widget.peer.username}",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      SizedBox(height: 6,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            height: (MediaQuery.of(context).size.height)-100,
            child:  ListView.builder(
              itemCount: widget.peer.messages.length,
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10,bottom: 10),
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                  child: Align(
                    alignment: (widget.peer.messages[index].messageType == "R"?Alignment.topLeft:Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (widget.peer.messages[index].messageType  == "R"?Colors.grey.shade200:Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(widget.peer.messages[index].message, style: TextStyle(fontSize: 18),),
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
                          hintText: "Write the message",
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
                      nearbyService.sendMessage(widget.peer.deviceId, typing.text);
                      widget.peer.messages.add(Messages("S", typing.text));
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
