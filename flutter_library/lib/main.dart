import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'linearbar_fill.dart';
import 'page_route_test.dart';

void main() => runApp(FlutterApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  @override
  _ExampleHomePageState createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  final EventChannel _eventChannel = EventChannel("stream_channel");
  StreamSubscription _subscription;
  double _receiverMessage = 1.0;
  final MethodChannel _methodChannel = MethodChannel("method_channel");

  @override
  void initState() {
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 6));
    print('MTMTMT ${window.defaultRouteName}');

    _animation = new Tween(begin: 0.0, end: _receiverMessage)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.decelerate));
    _animationController.forward();

    super.initState();

    _subscription = _eventChannel.receiveBroadcastStream().listen((data) {
      _receiverMessage = data.toDouble() / 100;

      if (_receiverMessage == 1.0) {
        _animation = new Tween(begin: _animation.value, end: _receiverMessage)
            .animate(CurvedAnimation(parent: _animationController, curve: Curves.decelerate));

        _animation.addListener(() => {
              setState(() {
                if (_animation.value == 1.0) {
                  _methodChannel.invokeMethod<bool>('finishProgress', 'Finish Progress');
                }
              })
            });
        _animationController.forward();
      }
    }, onError: (e) {
      _receiverMessage = 1.0;
    }, onDone: () {
      _receiverMessage = 1.0;
    }, cancelOnError: true);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return new Scaffold(
      body: new Container(
        decoration: BoxDecoration(
            gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(255, 78, 208, 253), Color.fromARGB(255, 200, 240, 254)],
        )),
        child: Center(
          child: new ListView(children: [
            Container(
              height: 300,
            ),
            Container(
                margin: EdgeInsets.only(right: 100, left: 100),
                child: LinearbarFill(
                  size: new Size(width, 10),
                  backgroundColor: const Color(0xFF2A2A2A),
                  value: _animation.value,
                )),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
