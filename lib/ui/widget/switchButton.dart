import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SwitchButton extends StatefulWidget {
  String title;
  bool controlValue;
  RawDatagramSocket? udp;
  List<int> data, data2;

  SwitchButton( 
    this.title,
    this.controlValue,
    this.udp,
    this.data,
    this.data2,
  );

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlutterSwitch(
          showOnOff: true,
          activeText: "ON",
          inactiveText: "OFF",
          value: widget.controlValue,
          onToggle: (value) async {
            setState(() {
              if (widget.udp != null) {
                widget.controlValue = value;
                if (widget.controlValue) {
                  widget.udp!.send(widget.data, InternetAddress("192.168.2.1"), 9742); //encender modulo
                } 
                else {
                  widget.udp!.send(widget.data2, InternetAddress("192.168.2.1"), 9742); //apagar modulo
                }
              }
            });
          },
        ),
        Text(widget.title),
      ],
    );
  }
}
