import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/repository/communication.dart';

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
          if('.'.allMatches(data.ctrl1!.text).length == 3){
            await startComm(data);
            if(soundStart == true){
              soundStart = false;
              await sendStartSound(data);
            }
          }
        }
        else{
          log("debes ingresar la direccion ip");
        }
      } : null,
    );
  }
}