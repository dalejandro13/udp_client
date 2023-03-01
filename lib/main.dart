import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/ui/widget/dropDown.dart';
import 'package:udp_client/ui/widget/scrollEnable.dart';
import 'package:udp_client/ui/widget/scrollText.dart';
import 'package:udp_client/ui/widget/switchButton.dart';
import 'package:udp_client/ui/widget/upperScreen.dart';
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

class _UdpCommunicationState extends State<UdpCommunication> with WidgetsBindingObserver {

  AppLifecycleState? _notification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) async {
      ProviderData d = Provider.of<ProviderData>(context, listen: false);
      d.ctrl1!.text = d.addressesIListenFrom.address;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flexolumens"),
        actions: const [
          DropButton()
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll){
          overScroll.disallowIndicator(); //deshabilita scroll glow
          return true;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const UpperScreen(),
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
              child: Center(
                child: statusMessage(data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}