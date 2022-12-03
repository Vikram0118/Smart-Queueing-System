import 'package:camera/camera.dart';
import 'package:qbeacon/fragments/ai_cam_sdm/homepage.dart';
import 'globalValues.dart';
import 'package:flutter/material.dart';
import 'package:qbeacon/splash_screen/splash_screen.dart';
import 'package:qbeacon/routes/pageRoute.dart';
import 'fragments/all.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  runApp(new QBeacon());
}

class QBeacon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QBeacon",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          caption: TextStyle(fontSize: 18.0),
          bodyText1: TextStyle(fontSize: 18.0),
        ),
        fontFamily: "PrintClearly",
      ),
      home: SplashScreen(),
      routes:  {
        pageRoutes.deals: (context) => DealsPage(),
        pageRoutes.sdm: (context) => SocialDistanceMonitor(),
        pageRoutes.people: (context) => PeoplePage(),
        pageRoutes.announcement: (context) => AnnouncementPage(),
        pageRoutes.messages: (context) => MessagesPage(),
        pageRoutes.profile: (context) => ProfilePage(),
        pageRoutes.about: (context) => AboutPage(),
        '/Home': (BuildContext context) => new CameraSocialDistanceMonitorTab(cameras)
      },
    );
  }
}

