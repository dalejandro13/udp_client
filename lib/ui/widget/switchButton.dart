import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/repository/communication.dart';

class SwitchButton extends StatefulWidget {
  String title;
  List<int> data, data2;
  ProviderData d;
  int module;

  SwitchButton( 
    this.title,
    this.data,
    this.data2,
    this.d,
    this.module,
  );

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: FlutterSwitch(
            showOnOff: true,
            activeText: "ON",
            inactiveText: "OFF",
            value: (widget.module == 1) ? widget.d.ozone! : (widget.module == 2) ? widget.d.compresor! : (widget.module == 3) ? widget.d.ionize! : widget.d.airFresh!,
            onToggle: (value) async {
              if(widget.d.enableSwitch == true){
                if(widget.module == 1){
                  widget.d.ozone = value;
                  if (widget.d.ozone!) {
                    widget.d.socket!.send(widget.data, widget.d.addresesToSend, widget.d.port); //encender modulo ozono
                    widget.d.startTimer = 30;
                    widget.d.takeMeasure = false;
                    await sTimer(widget.d); //inicia el timer
                  } 
                  else {
                    widget.d.socket!.send(widget.data2, widget.d.addresesToSend, widget.d.port); //apagar modulo ozono
                    widget.d.startTimer = 0; //apaga el timer
                  }
                }
                else if(widget.module == 2){
                  widget.d.compresor = value;
                  if (widget.d.compresor!) {
                    widget.d.socket!.send(widget.data, widget.d.addresesToSend, widget.d.port); //encender modulo compresor
                  } 
                  else {
                    widget.d.socket!.send(widget.data2, widget.d.addresesToSend, widget.d.port); //apagar modulo compresor
                  }
                }
                else if(widget.module == 3){
                  widget.d.ionize = value;
                  if (widget.d.ionize!) {
                    widget.d.socket!.send(widget.data, widget.d.addresesToSend, widget.d.port); //encender modulo ionizar
                  } 
                  else {
                    widget.d.socket!.send(widget.data2, widget.d.addresesToSend, widget.d.port); //apagar modulo ionizar
                  }
                }
                else{
                  widget.d.airFresh = value;
                  if (widget.d.airFresh!) {
                    widget.d.socket!.send(widget.data, widget.d.addresesToSend, widget.d.port); //encender modulo ambientador
                  } 
                  else {
                    widget.d.socket!.send(widget.data2, widget.d.addresesToSend, widget.d.port); //apagar modulo ambientador
                  }
                }
              }
            }
          ),
        ),
        Expanded(flex:1, child: Text(widget.title)),
      ],
    );
  }
}