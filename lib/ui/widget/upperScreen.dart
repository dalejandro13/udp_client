import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/ui/widget/actionButton.dart';
import 'package:udp_client/ui/widget/circularGreenButton.dart';

class UpperScreen extends StatefulWidget {
  const UpperScreen({Key? key}) : super(key: key);

  @override
  State<UpperScreen> createState() => _UpperScreenState();
}

class _UpperScreenState extends State<UpperScreen> {
  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(5.0)),
                CircularGreenButton("Iniciar", 2, data)
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children:[
                const Padding(padding: EdgeInsets.all(5.0)),
                ButtonActions("Limpiar pantalla", 1, data),
                const Padding(padding: EdgeInsets.all(2.0)),
                ButtonActions("Desconectar todo", 3, data),
              ]
            ),
          )
        ],
      ),
    );
  }
}