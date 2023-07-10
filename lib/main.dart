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
        title: "FlexoOzono",
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
    //WidgetsBinding.instance.addObserver(this); //es necesario descomentar esta linea de codigo para poder acceder a los diferentes ciclos de vida de la aplicacion
    WidgetsBinding.instance.addPostFrameCallback((time) async {
      ProviderData d = Provider.of<ProviderData>(context, listen: false);
      d.ctrl1!.text = d.addressesIListenFrom.address;
    });
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this); //remueve los eventos para detectar los ciclos de vida de la aplicacion
    super.dispose();
  }

  //este metodo junto con la linea de codigo: WidgetsBinding.instance.addObserver(this), permite mostrar los ciclos de vida de la aplicacion
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if(state == AppLifecycleState.paused){
  //     print("aplicacion pausada");
  //   }
  //   else if(state == AppLifecycleState.resumed){
  //     print("aplicacion reanudada");
  //   }
  // }

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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SwitchButton("Ozono", const [0x31], const [0x35], data, 1),
                  SwitchButton("Compresor", const [0x32], const [0x36], data, 2),
                  SwitchButton("Activación", const [0x33], const [0x37], data, 3),
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

/*
DOCUMENTACION:

1) CircularButton (Iniciar):
Cuando presiono el boton verde de la aplicacion, envio la trama: 0x55(U) para consultar el estado de las variables en el ESP.
EL ESP me regresa los siguientes datos: "U:31-32-33-34". 

En este caso la informacion se interpreta de la siguiente forma:
Cuando ozono esta activado (31) se habilita el switchButton "Ozono".
Cuando compresor esta activado (-32) se habilita el switchButton "Compresor".
Cuando activacion esta activado (-33) se habilita el switchButton "Activar".
Cuando ambientador esta activado (-34) se habilita el switchButton "Ambientador".

Luego se envia el comando 0x41(A) para que el ESP haga sonar el tono de inicio.

Luego desde el ESP se envia constantemente los valores de ozono de la siguiente forma: 
"O3 -> ppm: X.XXXX - ppb: YYYY"

Despues se activa el timer el cual activara automaticamente el ozono y el compresor pasado 5 minutos.

2) Boton "limpiar pantalla":
Este boton cuando se presiona no envia comandos al ESP, solo limpia la pantalla de la aplicacion.

3) Boton "desconectar todo":
Cuando se presiona este boton se envia el comando 0x39(9) para que el ESP apague todo el sistema.
Pero antes que de que se apague el ESP, el micro envia una ultima respuesta, envia una 'D:' para que la aplicacion
se desconecte del protocolo UDP y la interfaz se "reinicie".

4) SwitchButton:
ozono:       si lo activo se envia el comando 0x31(1) al ESP. Cuando se desactiva se envia el 0x35(5) al ESP
compresor:   si lo activo se envia el comando 0x32(2) al ESP. Cuando se desactiva se envia el 0x36(6) al ESP
activacion:  si lo activo se envia el comando 0x33(3) al ESP. Cuando se desactiva se envia el 0x37(7) al ESP
ambientador: si lo activo se envia el comando 0x34(4) al ESP. Cuando se desactiva se envia el 0x38(8) al ESP

5) Boton desplazar:
Ese boton, el cual es un checkBox, solo habilita ó deshabilita el autoScroll, no envia comandos para 
interactuar con el ESP.

*/