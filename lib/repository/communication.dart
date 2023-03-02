import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:http/http.dart' as http;

Timer? timer;

Future<void> startComm(ProviderData data) async {
  try{
    data.enterOnce = false;
    data.socket = await RawDatagramSocket.bind(data.addressesIListenFrom, data.port);    
    data.socket!.listen((RawSocketEvent e) async {
      Datagram? datagram = data.socket!.receive();
      if (datagram == null) return;

      if(data.isReceiving == true){
        data.isReceiving = false;
        data.isConnect = true;
        data.enableSwitch = true;
      }
      String? message;
      message = String.fromCharCodes(datagram.data).trim();

      if (message.contains("start")) { //llega comando de arranque de parte del ESP
        //solo dejar los bool
        data.ozone = true;
        //data.socket!.send([0x31], data.addresesToSend, data.port); //encender modulo ozono
        //await Future.delayed(const Duration(milliseconds: 1000));
        data.compresor = true;
        //data.socket!.send([0x32], data.addresesToSend, data.port); //encender modulo compresor
      }
      else if(message.contains("U:")){
        if(message.length > 2){
          if(message.contains("31")) data.ozone = true;
          if(message.contains("32")) data.compresor = true;
          if(message.contains("33")) data.ionize = true;
          if(message.contains("34")) data.airFresh = true;
          data.soundStart = false;
        }
      }
      else if(message.contains("D:")){
        await closeComm(data, false);
      }
      else { //llega informacion del sensor
        data.ctrl2?.text += "$message\n";
        await getValues(message, data);
        if (data.scrolling == true) {
          data.ctrl3?.animateTo(// esto hace autoscroll en TextFormField junto con SingleChildScrollView
            data.ctrl3!.position.maxScrollExtent,
            curve: Curves.easeOutBack,
            duration: const Duration(milliseconds: 100),
          );
        }
      }
    });
  }
  catch(e){
    log("ERROR: $e");
  }
}

Future<void> requestUpdateState(ProviderData data) async {
  data.socket!.send([0x55], data.addresesToSend, data.port); //envio la letra U para consultar estado de las variables
}

Future<void> getValues(String string, ProviderData data) async {
  String? result;
  int indexI = string.indexOf(":");
  int indexF = string.lastIndexOf("-");
  result = string.substring(indexI + 2, indexF - 1);
  data.ozoneValuePPM = double.parse(result); //convertir niveles de ozono (ppm) de string a double

  indexI = string.lastIndexOf(":");
  result = string.substring(indexI + 2, string.length);
  data.ozoneValuePPB = double.parse(result); //convertir niveles de ozono (ppb) de string a double
}

Future<void> sendStartSound(ProviderData data) async {
  data.socket!.send([0x41], data.addresesToSend, data.port); //envio la letra A para que el ESP reproduzca sonido de inicio
}

Future<void> closeComm(ProviderData data, bool send) async {
  if (data.socket != null) {
    data.isConnect = false;
    await turnOffAll(data, send);
    data.socket!.close();
    data.startTimer = 0;
    data.enterOnce = true;
    data.enableSwitch = false;
    data.soundStart = true;
  }
}

Future<void> turnOffAll(ProviderData data, bool send) async {
  if(send == true){ 
    data.socket!.send([0x39], data.addresesToSend, data.port); //apagar todo
  }
  data.ozone = false;
  data.compresor = false;
  data.ionize = false;
  data.airFresh = false;
  await Future.delayed(const Duration(milliseconds: 1000));
}

Future<void> sTimer(ProviderData data) async {
  timer = Timer.periodic(
    const Duration(seconds: 1),
    (Timer timer) {
      if (data.startTimer <= 0) {
        data.takeMeasure = true;
        timer.cancel();
      } 
      else {
        data.startTimer--;
      }
    },
  );
}

Future<void> isWifiActive(ProviderData data) async {
  // ConnectivityResult? _connectivityResult;
  // final ConnectivityResult result = await Connectivity().checkConnectivity();
  // if (result == ConnectivityResult.wifi) {
  //   data.soundStart = true;
  // } 
  // else {
  //   data.soundStart = false;
  // }

  try{
    dynamic response = await http.get(Uri.parse('http://192.168.2.1/consult')).timeout(const Duration(seconds: 3));
    if (response.statusCode == 200) {
      if(response.body.toString().contains("Medidor De Ozono")){
        data.soundStart = true;
      }
      else{
        data.soundStart = false;
      }
    } 
    else {
      data.soundStart = false;
    }
  }
  catch(e){
    data.soundStart = false;
  }
}