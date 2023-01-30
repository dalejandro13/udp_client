import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/repository/communication.dart';

class ButtonActions extends StatelessWidget {
  String title;
  int value;
  ProviderData data;

  ButtonActions(
    this.title, 
    this.value,
    this.data,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(title),
      onPressed: 
        (value == 1) ? //limpia pantalla
          (){
            data.ctrl2?.text = "";
          } : 
        (value == 2) ? //conectar
          (data.isConnect == false) ? 
            () async {
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
            } :
            null :
          (data.isConnect == true) ? () async { //desconectar todo
            await closeComm(data);
          } : null
    );
  }
}