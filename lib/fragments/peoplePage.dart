import 'package:qbeacon/navigationDrawer/navigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'package:qbeacon/globalValues.dart';


class PeoplePage extends StatefulWidget {
  static const String routeName = '/peoplePage';
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: admin.isHost? Text("People"):Text("Network"),),
        drawer: navigationDrawer(),
        body: ListView.builder(
            itemCount: getItemCount(),
            itemBuilder: (context, index) {
              final device = admin.isHost?
                  connectedDevices[index]
                  : devices[index];
              return Container(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                              onTap: () {},
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

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Colors.green;
      default:
        return Colors.red;
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

  int getItemCount() {
    if (admin.isHost) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
        nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }
}