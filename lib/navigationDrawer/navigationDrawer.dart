import 'package:flutter/material.dart';
import 'package:qbeacon/globalValues.dart';
import 'package:qbeacon/widget/createDrawerBodyItem.dart';
import 'package:qbeacon/widget/createDrawerHeader.dart';
import 'package:qbeacon/routes/pageRoute.dart';
import 'package:qbeacon/splash_screen/login/login.dart';


Widget navigationDrawer(){
  return admin.isHost? HostNavigationDrawer() : JoinNavigationDrawer();
}


class HostNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(height),
          createDrawerBodyItem(
              icon: Icons.shopping_basket,
              text: 'Deals of the day',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.deals)
          ),
          createDrawerBodyItem(
              icon: Icons.accessibility,
              text: 'Social Distance Monitor',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.sdm)
          ),
          createDrawerBodyItem(
              icon: Icons.people,
              text: 'People',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.people)
          ),
          createDrawerBodyItem(
              icon: Icons.announcement,
              text: 'Announcements',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.announcement)
          ),
          createDrawerBodyItem(
              icon: Icons.shopping_basket_rounded,
              text: 'Received Orders',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.messages)
          ),
          createDrawerBodyItem(
            icon: Icons.account_circle,
            text: 'My Profile',
            onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.profile),
          ),
          createDrawerBodyItem(
              icon: Icons.info,
              text: 'About',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.about),
          ),
          createDrawerBodyItem(
            icon: Icons.exit_to_app,
            text: 'Exit',
            onTap: (){
              if(admin.isHost){
                devices.forEach((element) {
                  nearbyService.disconnectPeer(deviceID: element.deviceId);
                });
              }
              subscription?.cancel();
              receivedDataSubscription?.cancel();
              nearbyService.stopBrowsingForPeers();
              nearbyService.stopAdvertisingPeer();
              joinChat.clear();
              receivedOrders.clear();
              joinAnnouncement.clear();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login( screenHeight: MediaQuery.of(context).size.height,)));
            },
          ),
        ],
      ),
    );
  }
}


class JoinNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(height),
          createDrawerBodyItem(
              icon: Icons.shopping_basket,
              text: 'Deals of the day',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.deals)
          ),
          createDrawerBodyItem(
              icon: Icons.accessibility,
              text: 'Social Distance Monitor',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.sdm)
          ),
          createDrawerBodyItem(
              icon: Icons.network_wifi,
              text: 'Network',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.people)
          ),
          createDrawerBodyItem(
              icon: Icons.announcement,
              text: 'Announcements',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.announcement)
          ),
          createDrawerBodyItem(
              icon: Icons.shopping_basket_rounded,
              text: 'Orders',
              onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.messages)
          ),
          createDrawerBodyItem(
            icon: Icons.account_circle,
            text: 'My Profile',
            onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.profile),
          ),
          createDrawerBodyItem(
            icon: Icons.info,
            text: 'About',
            onTap: () => Navigator.pushReplacementNamed(context, pageRoutes.about),
          ),
          createDrawerBodyItem(
            icon: Icons.exit_to_app,
            text: 'Exit',
            onTap: () {
              if(!admin.isHost){
                devices.forEach((element) {
                  nearbyService.disconnectPeer(deviceID: element.deviceId);
                });
              }
              subscription?.cancel();
              receivedDataSubscription?.cancel();
              nearbyService.stopBrowsingForPeers();
              nearbyService.stopAdvertisingPeer();
              joinChat.clear();
              joinAnnouncement.clear();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login( screenHeight: MediaQuery.of(context).size.height,)));
            },
          ),
        ],
      ),
    );
  }
}