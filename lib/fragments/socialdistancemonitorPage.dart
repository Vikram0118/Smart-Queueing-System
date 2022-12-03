import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:qbeacon/fragments/ai_cam_sdm/homepage.dart';
import 'package:qbeacon/widget/sDmWidget.dart';
import 'package:qbeacon/globalValues.dart';
import 'package:qbeacon/navigationDrawer/navigationDrawer.dart';
import "package:system_settings/system_settings.dart";


class SocialDistanceMonitor extends StatefulWidget {
  static const String routeName = '/socialDistancemonitorPage';
  @override
  _SocialDistanceMonitorState createState() => _SocialDistanceMonitorState();
}

class _SocialDistanceMonitorState extends State<SocialDistanceMonitor> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: new Scaffold(
          appBar: AppBar(
            title: Text("Social Distance Monitor"),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.transparent,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.camera_alt,
                    color: Colors.black,
                  ),
                ), // Camera
                Tab(
                  icon: Icon(Icons.bluetooth_connected_outlined,
                    color: Colors.black,
                  ),
                ), //Bluetooth

              ],
            ),
          ),
          drawer: navigationDrawer(),
          body: TabBarView(
            children: <Widget>[
              CameraSocialDistanceMonitorTab(cameras),
              BluetoothSocialDistanceMonitorTab(),
            ],
          ),
        )
    );

  }
}




class BluetoothSocialDistanceMonitorTab extends StatefulWidget {

  @override
  _BluetoothSocialDistanceMonitorTabState createState() => _BluetoothSocialDistanceMonitorTabState();
}

class _BluetoothSocialDistanceMonitorTabState extends State<BluetoothSocialDistanceMonitorTab> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }
  // ignore: non_constant_identifier_names
  Widget call_scan()
  {
    if(_bluetoothState.isEnabled)
      {
        return DiscoveryPage();

      }
    else
      {
        return new Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child:AppBar(
            title: Text("Near by Devices"),
            automaticallyImplyLeading: false,
            ),
          ),
          body: Center(
            child:Text("Turn on bluetooth to view Near by Devices",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
          ),
          ),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    return  new Container(
        child:  Column(
          children: <Widget>[
            Container(
              height: (height-80)/2.3,
              child: ListView(
                children: <Widget>[
                  ListTile(title: const Text(
                    'My Device',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  ),
                  SwitchListTile(
                    title: const Text('Enable Bluetooth For SDM'),
                    value: _bluetoothState.isEnabled,
                    onChanged: (bool value) {
                      future() async {
                        if (value) {
                          await FlutterBluetoothSerial.instance.requestEnable();
                          SystemSettings.system();
                        }
                        else {
                          await FlutterBluetoothSerial.instance.requestDisable();
                        }
                      }
                      future().then((_) {
                        setState(() {});
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('Local adapter address'),
                    subtitle: Text(_address),
                  ),
                  ListTile(
                    title: const Text('Local adapter name'),
                    subtitle: Text(_name),
                    onLongPress: null,
                  ),
                ],
              ),
            ),
            Container(
              height: (height-140)-((height-60)/2.1),
              child: call_scan(),
            ),
          ],
        )
    );
  }
}

class DiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;

  const DiscoveryPage({this.start = true});

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;

  _DiscoveryPage();

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });
    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          setState(() {
            results.add(r);
          });
        });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
    Future.delayed(Duration(seconds: 15),()=> _restartDiscovery());
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(40.0), // here the desired height
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Near By Devices"),
          actions: <Widget>[
            isDiscovering
                ? FittedBox(
              child: Container(
                margin: new EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
                : IconButton(
              icon: Icon(Icons.replay),
              onPressed: _restartDiscovery,
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          return BluetoothDeviceListEntry(
            device: result.device,
            rssi: result.rssi,
          );
        },
      ),
    );
  }
}
