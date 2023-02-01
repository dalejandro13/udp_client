import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';

Timer? timer;

Future<void> startComm(ProviderData data) async {
  data.socket = await RawDatagramSocket.bind(data.addressesIListenFrom, data.port);    
  data.socket!.listen((RawSocketEvent e) async {
    Datagram? datagram = data.socket!.receive();
    if (datagram == null) return;

    if(data.isReceiving == true){
      data.isReceiving = false;
      data.isConnect = true;
      data.closing = true;
      data.enableSwitch = true;
    }

    String message = String.fromCharCodes(datagram.data).trim();

    if (message.contains("start")) { //llega comando de arranque de parte del ESP
      data.ozone = true;
      data.socket!.send([0x31], data.addresesToSend, data.port); //encender modulo ozono
      await Future.delayed(const Duration(milliseconds: 1000));
      data.compresor = true;
      data.socket!.send([0x32], data.addresesToSend, data.port); //encender modulo compresor
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

    if (data.isConnect == false) {
      if (data.closing == true) {
        await turnOffAll(data);
        data.closing = false;
        data.socket!.close();
        //data.socket = null;
        datagram = null;
        data.startTimer = 0;
        data.enterOnce = true;
        data.enableSwitch = false;
      }
    }
  });
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
  data.socket!.send([0x41], data.addresesToSend, data.port); //enviar comando para que el ESP reproduzca sonido de inicio
}

Future<void> closeComm(ProviderData data) async {
  if (data.socket != null) {
    data.isConnect = false;
  }
}

Future<void> turnOffAll(ProviderData data) async {
  data.socket!.send([0x39], data.addresesToSend, data.port); //apagar todo
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
      if (data.startTimer == 0) {
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
  ConnectivityResult? _connectivityResult;
  final ConnectivityResult result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.wifi) {
    data.soundStart = true;
  } 
  else {
    data.soundStart = false;
  }
}