import 'package:qbeacon/navigationDrawer/navigationDrawer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:qbeacon/globalValues.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';



class DealsPage extends StatefulWidget {

  static const String routeName = '/dealsPage';

  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {

  @override
  void initState() {
    // TODO: implement initState
    hostQB();
    super.initState();
  }

  void hostQB() async{
    nearbyService = NearbyService();
    await nearbyService.init(
        serviceType: 'mp-connection',
        strategy: Strategy.P2P_STAR,
        callback: (isRunning) async {
          if (isRunning) {
            if (admin.isHost) {
              print("Search New Peer" );
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.startAdvertisingPeer();

              await nearbyService.stopBrowsingForPeers();
              await nearbyService.startBrowsingForPeers();
            }
          }
        });
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) {
          devicesList?.forEach((element) {
            print(
                " deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");

            if (Platform.isAndroid) {
              if (element.state == SessionState.connected) {
                nearbyService.stopBrowsingForPeers();
              } else {
                nearbyService.startBrowsingForPeers();
              }
            }
          });


         setState(() {
           print("Started List");
           devices.clear();
           devices.addAll(devicesList);
           connectedDevices.clear();
           print("Later List List");
           connectedDevices.addAll(devicesList
               .where((d) => d.state == SessionState.connected)
               .toList());
         });
        });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Deals of the day"),
        ),
        drawer:  navigationDrawer(),
        body: Container(
          decoration: BoxDecoration(image: DecorationImage(image: new ExactAssetImage('assets/deals.jpg'), fit: BoxFit.cover,),)
        ),
    );
  }
}

