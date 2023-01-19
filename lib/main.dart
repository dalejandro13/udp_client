import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:udp_client/ui/widget/switchButton.dart';
import 'package:udp_client/ui/widget/warningMessage.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UdpCommunication(),
    )
  );
}

class UdpCommunication extends StatefulWidget {
  const UdpCommunication({ Key? key }) : super(key: key);

  @override
  State<UdpCommunication> createState() => _UdpCommunicationState();
}

class _UdpCommunicationState extends State<UdpCommunication> {
  
  InternetAddress addressesIListenFrom = InternetAddress.anyIPv4;
  InternetAddress addresesToSend = InternetAddress("192.168.2.1");
  int port = 9742; //0 is random
  bool? scrolling = true, isConnect = false, closing = false;
  TextEditingController? ctrl1 = TextEditingController();
  TextEditingController? ctrl2 = TextEditingController();
  ScrollController? ctrl3 = ScrollController();
  RawDatagramSocket? udp;
  int valueOzoneLevel = 0;
  bool ozono = false, compresor = false, ionizar = false, airFresh = false;

  @override
  void initState() {
    super.initState();
    ctrl1!.text = addressesIListenFrom.address;
  }


  Future<void> startComm() async {
    try{
      RawDatagramSocket.bind(addressesIListenFrom, port).then((RawDatagramSocket? socket) async {
        // log('Datagram socket ready to receive');
        // log('${socket!.address.address}:${socket.port}');
        udp = socket;
        isConnect = true;
        closing = true;
        socket!.listen((RawSocketEvent e) async {
          Datagram? d = socket!.receive();
          if (d == null) return;

          String message = String.fromCharCodes(d.data).trim();
          valueOzoneLevel = int.parse(message); //convertir niveles de ozono de string a int
          //log('Datagram from ${d.address.address}:${d.port}\n');
          //log('message: $message\n');
          ctrl2?.text += "$message\n";
          if(scrolling == true){
            ctrl3?.animateTo( //esto hace autoscroll en TextFormField junto con SingleChildScrollView
              ctrl3!.position.maxScrollExtent,
              curve: Curves.easeOutBack,
              duration: const Duration(milliseconds: 100),
            );
          }

          if(isConnect == false){
            try{
              if(closing == true){
                await turnOffAll();
                closing = false;
                socket!.close();
                udp!.close();
                socket = null;
                udp = null;
                d = null;
              }
            }
            catch(e) {
              log("ERROR: $e");
            }
          }

          setState(() { });
        });
      });
    }
    catch(e){
      log("ERROR: $e");
    }
  }

  Future<void> closeComm() async {
    if(udp != null){
      isConnect = false;
    }
  }

  Future<void> turnOffAll() async {
    udp!.send([0x35], addresesToSend, port); //apagar ozono
    ozono = false;
    await Future.delayed(const Duration(milliseconds: 500));
    udp!.send([0x36], addresesToSend, port); //apagar compresor
    compresor = false;
    await Future.delayed(const Duration(milliseconds: 500));
    udp!.send([0x37], addresesToSend, port); //apagar ionizar
    ionizar = false;
    await Future.delayed(const Duration(milliseconds: 500));
    udp!.send([0x38], addresesToSend, port); //apagar ambientador
    airFresh = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flexolumens"),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll){
          overScroll.disallowIndicator(); //deshabilita scroll glow
          return true;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top:25.0),),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 25.0,
                      width: 200.0,
                      child: Text("Puerto: $port")
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  ElevatedButton(
                    onPressed: () async {
                      ctrl2?.text = "";
                    }, 
                    child: const Text("limpiar pantalla"),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Direccion IP: "),
                  ),
                  SizedBox(
                    height: 15.0,
                    width: 60.0,
                    child: TextFormField(
                      readOnly: true,
                      controller: ctrl1,
                    ),
                  ),
                  ElevatedButton(
                    child: const Text("Conectar"),
                    onPressed: (isConnect == false) ? () async {
                      if(ctrl1!.text.isNotEmpty){
                        if('.'.allMatches(ctrl1!.text).length == 3){
                          await startComm();
                        }
                      }
                      else{
                        log("debes ingresar la direccion ip");
                      }
                      setState(() { });
                    } : null, 
                  ),
                  //const SizedBox(width: 1.0,),
                  ElevatedButton(
                    child: const Text("desconectar\n       todo"),
                    onPressed: (isConnect == true) ? () async {
                      await closeComm();
                    } : null,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(
                  maxHeight: 100.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: ctrl3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none
                      ),
                      keyboardType: TextInputType.multiline,
                      readOnly: true,
                      controller: ctrl2,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: scrolling,
                    onChanged: (bool? value) {
                      setState(() {
                        scrolling = value;
                      });
                    },
                  ),
                  const Text("desplazar"),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SwitchButton("Ozono", false, udp, const [0x31], const [0x35]),
                  SwitchButton("Compresor", false, udp, const [0x32], const [0x36]),
                  SwitchButton("Ionizar", false, udp, const [0x33], const [0x37]),
                  SwitchButton("Ambientador", false, udp, const [0x34], const [0x38]),

                  /*
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterSwitch(
                        showOnOff: true,
                        activeText: "ON",
                        inactiveText: "OFF",
                        value: ozono,
                        onToggle: (value) async {
                          setState(() {
                            if(udp != null){
                              ozono = value;
                              if(ozono){
                                udp!.send([0x31], addresesToSend, port); //encender ozono
                              }
                              else{
                                udp!.send([0x35], addresesToSend, port); //apagar ozono
                              }
                            }
                          });
                        },
                      ),
                      const Text("Ozono"),
                    ],
                  ),

                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterSwitch(
                        showOnOff: true,
                        activeText: "ON",
                        inactiveText: "OFF",
                        value: compresor,
                        onToggle: (value) async {
                          setState(() {
                            if(udp != null){
                              compresor = value;
                              if(compresor){
                                udp!.send([0x32], addresesToSend, port); //encender compresor
                              }
                              else{
                                udp!.send([0x36], addresesToSend, port); //apagar compresor
                              }
                            }
                          });
                        },
                      ),
                      const Text("Compresor"),
                    ],
                  ),


                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterSwitch(
                        showOnOff: true,
                        activeText: "ON",
                        inactiveText: "OFF",
                        value: ionizar,
                        onToggle: (value) async {
                          setState(() {
                            if(udp != null){
                              ionizar = value;
                              if(ionizar){
                                udp!.send([0x33], addresesToSend, port); //encender ionizar
                              }
                              else{
                                udp!.send([0x37], addresesToSend, port); //apagar ionizar
                              }
                            }
                          });
                        },
                      ),
                      const Text("Ionizar"),
                    ],
                  ),


                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterSwitch(
                        showOnOff: true,
                        activeText: "ON",
                        inactiveText: "OFF",
                        value: airFresh,
                        onToggle: (value) async {
                          setState(() {
                            if(udp != null){
                              airFresh = value;
                              if(airFresh){
                                udp!.send([0x34], addresesToSend, port); //encender ambientador
                              }
                              else{
                                udp!.send([0x38], addresesToSend, port); //apagar ambientador
                              }
                            }
                          });
                        },
                      ),
                      const Text("Ambientador"),
                    ],
                  ),
                  */


                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (isConnect == true) ?
                  (valueOzoneLevel <= 0) ? 
                    WarningMessage(title: "Ambiente Seguro", col: Colors.green): 
                    WarningMessage(title: "Peligro Ozono en el ambiente", col: Colors.red):
                    WarningMessage(title: "", col: Colors.black),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top:25.0),),
          ],
        ),
      ),
    );
  }
}