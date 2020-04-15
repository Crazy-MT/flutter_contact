import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:core';

class LinearbarFill extends StatefulWidget {
  final Size size;
  final Color backgroundColor;
  final Color color;
  final double value;

  LinearbarFill(
      {@required this.size,
      this.backgroundColor = Colors.grey,
      this.color = Colors.blue,
      @required this.value});

  @override
  _LinearbarFill createState() => new _LinearbarFill();
}

class _LinearbarFill extends State<LinearbarFill>
    with SingleTickerProviderStateMixin {
/*  AnimationController controller;
  Animation animation;*/

  @override
  void initState() {
    // TODO: implement initState
    /*controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10000))
      ..repeat();
    animation = Tween(begin: 0.0, end: widget.size.width).animate(controller);
    controller.addListener(() {
      setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
//    print(widget.size.width);
//    print(widget.value);
//    print(widget.value * widget.size.width);
    return new Container(
      width: widget.size.width,
      height: widget.size.height,
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              new Container(
                height: widget.size.height,
                decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 92, 81, 162),
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(widget.size.height / 2)),
//                border: new Border.all(color: widget.backgroundColor, style: BorderStyle.solid, width: widget.size.height/3)
                ),
                alignment: Alignment.centerLeft,
                child: new Padding(
                  padding: new EdgeInsets.all(0.0),
                  child: new Container(
                    height: widget.size.height,
                    width: widget.value * widget.size.width,
                    decoration: new BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(widget.size.height / 2)),
                        gradient: new LinearGradient(
                          colors: [Color.fromARGB(255, 69, 147, 173), Color.fromARGB(255, 54, 202, 252)],
                        )),
                    /*child: new Padding(
                      padding: new EdgeInsets.only(right: 4.0),
                      child: new Text(
                          '${(animation.value / widget.size.width * 100).round()}',
                          style: new TextStyle(
                              fontSize: widget.size.width / 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),*/
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
            ],
          )),
//        new SizedBox(width: widget.size.width/8,
//          child: new Text('${(animation.value/(7*widget.size.width/8 - 2*widget.size.height/3)*100).round()}%',
//          textAlign: TextAlign.center, style: new TextStyle(fontSize: widget.size.width/25, fontWeight: FontWeight.bold),),
//        ),
        ],
      ),
    );
  }
}
