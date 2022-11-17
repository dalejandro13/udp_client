import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

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
  
  var addressesIListenFrom = InternetAddress.anyIPv4;
  int port = 9742; //0 is random
  bool? change = true;
  TextEditingController? ctrl1 = TextEditingController();
  TextEditingController? ctrl2 = TextEditingController();
  ScrollController? ctrl3 = ScrollController();

  @override
  void initState() {
    super.initState();
    ctrl1!.text = addressesIListenFrom.address;
  }


  Future<void> startComm() async {
    try{
      RawDatagramSocket.bind(addressesIListenFrom, port).then((RawDatagramSocket? socket){
        log('Datagram socket ready to receive');
        log('${socket!.address.address}:${socket.port}');
        socket.listen((RawSocketEvent e){
          Datagram? d = socket.receive();
          if (d == null) return;

          String message = String.fromCharCodes(d.data).trim();
          //log('Datagram from ${d.address.address}:${d.port}\n');
          //log('message: $message\n');
          ctrl2?.text += "$message\n";
          if(change == true){
            ctrl3?.animateTo( //esto hace autoscroll en TextFormField junto con SingleChildScrollView
              ctrl3!.position.maxScrollExtent,
              curve: Curves.easeOutBack,
              duration: const Duration(milliseconds: 100),
            );
          }
        });
      });
    }
    catch(e){
      log("ERROR: $e");
    }
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 25.0,
                      width: 200.0,
                      child: Text("Port: $port")
                    ),
                  ),
                  const SizedBox(width: 65.0),
                  ElevatedButton(
                    onPressed: () async {
                      ctrl2?.text = "";
                    }, 
                    child: const Text("Clear"),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("IP Address: "),
                  ),
                  const SizedBox(width: 15.0),
                  SizedBox(
                    height: 15.0,
                    width: 100.0,
                    child: TextFormField(
                      readOnly: true,
                      controller: ctrl1,
                    ),
                  ),
                  const SizedBox(width: 75.0),
                  ElevatedButton(
                    onPressed: () async {
                      if(ctrl1!.text.isNotEmpty){
                        if('.'.allMatches(ctrl1!.text).length == 3){
                          await startComm();
                        }
                      }
                      else{
                        log("debes ingresar la direccion ip");
                      }
                    }, 
                    child: const Text("Connect"),
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
                    value: change,
                    onChanged: (bool? value) {
                      setState(() {
                        change = value;
                      });
                    },
                  ),
                  const Text("autoscroll"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}