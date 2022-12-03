import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'package:qbeacon/globalValues.dart';
import 'package:qbeacon/fragments/all.dart';


class QBeaconSearch extends StatefulWidget {
  @override
  _QBeaconSearchState createState() => _QBeaconSearchState();
}

class _QBeaconSearchState extends State<QBeaconSearch> {

  @override
  void initState() {
    // TODO: implement initState
    joinQB();
    super.initState();
  }
  void joinQB()async{
    nearbyService = NearbyService();
    await nearbyService.init(
        serviceType: 'mp-connection',
        strategy: Strategy.P2P_STAR,
        callback: (isRunning) async {
          if (isRunning) {
            print("Search Host");
            await nearbyService.stopBrowsingForPeers();
            await nearbyService.startBrowsingForPeers();
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
            connectedDevices.addAll(devicesList
                .where((d) => d.state == SessionState.connected)
                .toList());
            print("Later List");
          });
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Searching for QBeacons"),),
        body: ListView.builder(
            itemCount: getItemCount(),
            itemBuilder: (context, index) {
              final device = admin.isHost
                  ? connectedDevices[index]
                  : devices[index];
              return Container(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              children: [
                                Text(device.deviceName),
                                Text(
                                  getStateName(device.state),
                                  style: TextStyle(
                                      color: getStateColor(device.state)),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                        ),

                        // Request connect
                        GestureDetector(
                          onTap: () => _onButtonClicked(device),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            padding: EdgeInsets.all(8.0),
                            height: 35,
                            width: 100,
                            color: getButtonColor(device.state),
                            child: Center(
                              child: Text(
                                getButtonStateName(device.state),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 8.0,),

                    Divider(height: 1, color: Colors.grey,)
                  ],
                ),
              );
            })
    );
  }


  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        return "connected";
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return "Connect";
      default:
        return "Disconnect";
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.black;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  _onButtonClicked(Device device) {
      switch (device.state) {
        case SessionState.notConnected:
          nearbyService.invitePeer(
            deviceID: device.deviceId,
            deviceName: device.deviceName,
          );
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DealsPage()));
          });
          break;
        case SessionState.connected:
          nearbyService.disconnectPeer(deviceID: device.deviceId);
          break;
        case SessionState.connecting:
          break;
      }
  }

  int getItemCount() {
    if (admin.isHost) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }
}
