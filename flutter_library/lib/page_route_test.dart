import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _buildWidgetForNativeRoute(window.defaultRouteName),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0XFF008577),
        accentColor: Color(0xFFD81B60),
        primaryColorDark: Color(0xFF00574B),
        iconTheme: IconThemeData(color: Color(0xFFD81B60)),
      ),
    );
  }
}

/// 该方法用于判断原生界面传递过来的路由值，加载不同的页面
Widget _buildWidgetForNativeRoute(String route) {
  switch (route) {
    case 'route_flutter':
      return GreetFlutterPage();
    case 'route_contact':
      return FlutterContact();
    // 默认的路由值为 '/'，所以在 default 情况也需要返回页面，
    // 否则 dart 会报错，这里默认返回空页面
    default:
      return Scaffold();
  }
}

class GreetFlutterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NativeMessageContactPage'),
      ),
      body: Center(
        child: Text(
          'This is a flutter fragment page',
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
      ),
    );
  }
}

class FlutterContact extends StatefulWidget {
  @override
  _FlutterContactPageState createState() {
    return new _FlutterContactPageState();
  }
}

class _FlutterContactPageState extends State<FlutterContact> {
  final MethodChannel _methodChannel = MethodChannel("method_channel");
  final EventChannel _eventChannel = EventChannel("stream_channel");
  final BasicMessageChannel _messageChannel =
      BasicMessageChannel("flutter_channel", StandardMessageCodec());
  StreamSubscription _subscription;

  var _receiverMessage = 'Start receive state';

  @override
  void initState() {
    super.initState();
    _subscription = _eventChannel.receiveBroadcastStream().listen((data) {
      setState(() {
        _receiverMessage = 'receive state value: $data';
      });
    }, onError: (e) {
      _receiverMessage = 'process error: $e';
    }, onDone: () {
      _receiverMessage = 'receive data done';
    }, cancelOnError: true);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Icon(Icons.arrow_back),
          ),
          onTap: () {
            _methodChannel.invokeMethod<bool>('finish', 'Finish Activity').then((result) {
              print('${result ? ' has finish' : 'not finish'}');
            }).catchError((e) {
              print('error happend: $e');
            });
          },
        ),
        title: Text('Flutter Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _receiverMessage,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ),
            RaisedButton(
              onPressed: () {
                _messageChannel.send('"Hello Native" --- an message from flutter').then((str) {
                  print('Receive message: $str');
                });
              },
              child: Text('Send Message to Native'),
            )
          ],
        ),
      ),
    );
  }
}
