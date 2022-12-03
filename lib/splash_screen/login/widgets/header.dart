import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'fade_slide_transition.dart';
import 'package:qbeacon/splash_screen/login/ui_constants.dart';

class Header extends StatelessWidget {
  final Animation<double> animation;

  const Header({
    @required this.animation,
  }) : assert(animation != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 0.0,
            child: Container(
              height: 80.0,
              width: 80.0,
              child: Image.asset("assets/QB2.png", fit: BoxFit.cover,),
            ),
          ),
          const SizedBox(height: kSpaceS),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 0.0,
            child: Text(
              'Welcome to QBeacon',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: kWhite, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: kSpaceS),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 16.0,
            child: Text(
              "Smart Queueing System",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: kWhite.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: kSpaceS),
        ],
      ),
    );
  }
}
