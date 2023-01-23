import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/ui/widget/scrollEnable.dart';
import 'package:udp_client/ui/widget/scrollText.dart';
import 'package:udp_client/ui/widget/switchButton.dart';
import 'package:udp_client/ui/widget/upperScreen1.dart';
import 'package:udp_client/ui/widget/upperScreen2.dart';
import 'package:udp_client/ui/widget/warningMessage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderData()),
      ],
      child: const MaterialApp(
        title: "ozone aplication",
        debugShowCheckedModeBanner: false,
        home: UdpCommunication(),
      ),
    )
  );
}

class UdpCommunication extends StatefulWidget {
  const UdpCommunication({ Key? key }) : super(key: key);

  @override
  State<UdpCommunication> createState() => _UdpCommunicationState();
}

class _UdpCommunicationState extends State<UdpCommunication> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      ProviderData d = Provider.of<ProviderData>(context, listen: false);
      d.ctrl1!.text = d.addressesIListenFrom.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
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
            //const Padding(padding: EdgeInsets.only(top:25.0),),
            const UpperScreen1(),
            const UpperScreen2(),
            ScrollText(data),
            ScrollEnable(data),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SwitchButton("Ozono", const [0x31], const [0x35], data, 1),
                  SwitchButton("Compresor", const [0x32], const [0x36], data, 2),
                  SwitchButton("Ionizar", const [0x33], const [0x37], data, 3),
                  SwitchButton("Ambientador", const [0x34], const [0x38],data, 4),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (data.isConnect == true) ?
                  (data.ozoneValuePPM <= 0.0) ? 
                    WarningMessage("Ambiente Seguro", Colors.green): 
                    WarningMessage("Peligro Ozono en el ambiente", Colors.red):
                    WarningMessage("", Colors.black),
                ],
              ),
            ),
            //const Padding(padding: EdgeInsets.only(top:25.0),),
          ],
        ),
      ),
    );
  }
}