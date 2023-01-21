import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/ui/widget/actionButton.dart';
import 'package:udp_client/ui/widget/scrollEnable.dart';
import 'package:udp_client/ui/widget/scrollText.dart';
import 'package:udp_client/ui/widget/switchButton.dart';
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
     WidgetsBinding.instance?.addPostFrameCallback((time) {
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
                      child: Text("Puerto: ${data.port}")
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  ButtonActions("Limpiar pantalla", 1, data),
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
                      controller: data.ctrl1,
                    ),
                  ),
                  ButtonActions("Conectar", 2, data),
                  ButtonActions("Desconectar\n       todo", 3, data),
                ],
              ),
            ),
            ScrollText(data),
            ScrollEnable(data),
            Expanded(
              flex: 2,
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
            const Padding(padding: EdgeInsets.only(top:25.0),),
          ],
        ),
      ),
    );
  }
}