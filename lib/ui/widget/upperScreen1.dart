import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/ui/widget/actionButton.dart';

class UpperScreen1 extends StatefulWidget {
  const UpperScreen1({Key? key}) : super(key: key);

  @override
  State<UpperScreen1> createState() => _UpperScreen1State();
}

class _UpperScreen1State extends State<UpperScreen1> {
  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return Expanded(
      flex: 1,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              height: 25.0,
              width: 200.0,
              child: Text("Puerto: ${data.port}")
            ),
          ),
          const SizedBox(width: 5.0),
          ButtonActions("Limpiar pantalla", 1, data),
        ],
      ),
    );
  }
}