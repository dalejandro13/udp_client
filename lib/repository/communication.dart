import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';


bool closing = false;

Future<void> startComm(ProviderData data) async {
  RawDatagramSocket.bind(data.addressesIListenFrom, data.port).then((RawDatagramSocket? socket) async {
    try{
      // log('Datagram socket ready to receive');
      // log('${socket!.address.address}:${socket.port}');
      data.udp = socket;
      data.isConnect = true;
      closing = true;
      socket!.listen((RawSocketEvent e) async {
        Datagram? datagram = socket!.receive();
        if (datagram == null) return;

        String message = String.fromCharCodes(datagram.data).trim();
        //log('Datagram from ${d.address.address}:${d.port}\n');
        //log('message: $message\n');
        data.ctrl2?.text += "$message\n";
        await getValues(message, data);
        if(data.scrolling == true){
          data.ctrl3?.animateTo( //esto hace autoscroll en TextFormField junto con SingleChildScrollView
            data.ctrl3!.position.maxScrollExtent,
            curve: Curves.easeOutBack,
            duration: const Duration(milliseconds: 100),
          );
        }

        if(data.isConnect == false){
          if(closing == true){
            await turnOffAll(data);
            closing = false;
            socket!.close();
            data.udp!.close();
            socket = null;
            data.udp = null;
            datagram = null;
          }
        }
      });
    }
    catch(e){
      log("ERROR1: $e");
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

Future<void> closeComm(ProviderData data) async {
  if(data.udp != null){
    data.isConnect = false;
  }
}

Future<void> turnOffAll(ProviderData data) async {
  data.udp!.send([0x35], data.addresesToSend, data.port); //apagar ozono
  data.ozone = false;
  await Future.delayed(const Duration(milliseconds: 50));
  data.udp!.send([0x36], data.addresesToSend, data.port); //apagar compresor
  data.compresor = false;
  await Future.delayed(const Duration(milliseconds: 50));
  data.udp!.send([0x37], data.addresesToSend, data.port); //apagar ionizar
  data.ionize = false;
  await Future.delayed(const Duration(milliseconds: 50));
  data.udp!.send([0x38], data.addresesToSend, data.port); //apagar ambientador
  data.airFresh = false;
}