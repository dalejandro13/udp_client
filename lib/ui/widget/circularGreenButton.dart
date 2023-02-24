import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/repository/communication.dart';
import 'package:udp_client/ui/widget/warningMessage.dart';

class CircularGreenButton extends StatelessWidget {
  String title;
  int value;
  ProviderData data;
  
  CircularGreenButton(
    this.title, 
    this.value,
    this.data,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(100, 100),
        shape: const CircleBorder(),
        backgroundColor: Colors.green[400], 
      ),
      onPressed: (data.isConnect == false) ? () async {
        if(data.ctrl1!.text.isNotEmpty){
          data.isReceiving = true;
          await isWifiActive(data);
          if(data.soundStart == true){
            if(data.enterOnce == true){
              await startComm(data);
              await requestUpdateState(data);
            }
            data.soundStart = false;
            if(data.avoidPlaySound == true){
              await sendStartSound(data);
            }
          }
          else{
            await showMessage(context);
          }
        }
        else{
          log("debes ingresar la direccion ip");
        }
      } : null,
    );
  }
}