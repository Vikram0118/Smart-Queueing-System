import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';


class Refresher extends Model{

  void reloadAll(){
    print("Widget Reloading Enabled");
    notifyListeners();
  }

}

class User{
  String _username;
  bool _isHost;

  User(this._username, this._isHost);

  String get username => this._username;
  bool get isHost => this._isHost;

  set username(newName) => this._username = newName;
  set isHost(newValue) => this._isHost = newValue;
}

User admin = User("admin", false);

class Messages{
  String messageType;
  String message;

  Messages(this.messageType, this.message);
}

class Chats{
  String _deviceID;
  String _username;
  List<Messages> messages;

  Chats(this._deviceID, this._username, this.messages);

  String get deviceId => this._deviceID;
  String get username => this._username;

  set deviceId(newId) => this._deviceID = newId;
  set username(newName) => this._username = newName;

}

List<Chats> receivedOrders = List();
List<Messages> joinChat = List();
List<Messages> joinAnnouncement = List();

//QBeacon NetWork Variables
List<Device> devices = [];
List<Device> connectedDevices = [];
NearbyService nearbyService;
StreamSubscription subscription;
StreamSubscription receivedDataSubscription;

List<CameraDescription> cameras;
AudioCache audioCache = AudioCache(prefix: "assets/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));


const Color BG_Color = Color(0xFF070B34);

const Gradient clip1 = LinearGradient(
  begin: Alignment.topLeft,
  end:Alignment(1.0,0.0),
  colors: [
    const Color(0xFF80D8FF),
    const Color(0xFF303F9F),
    const Color(0xFF80D8FF),
  ],
  tileMode: TileMode.repeated,
);

const Gradient clip2 = LinearGradient(
  begin: Alignment.topLeft,
  end:Alignment(1.0,0.0),
  colors: [
    const Color(0xFF303F9F),
    const Color(0xFF80D8FF),
    const Color(0xFF01579B),
  ],
  tileMode: TileMode.repeated,
);