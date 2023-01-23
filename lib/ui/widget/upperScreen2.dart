import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udp_client/bloc/providerData.dart';
import 'package:udp_client/ui/widget/actionButton.dart';

class UpperScreen2 extends StatefulWidget {
  const UpperScreen2({Key? key}) : super(key: key);

  @override
  State<UpperScreen2> createState() => _UpperScreen2State();
}

class _UpperScreen2State extends State<UpperScreen2> {
  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return Expanded(
      flex: 1,
      child: Row(
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
          const SizedBox(width: 15.0),
          ButtonActions("Conectar", 2, data),
          const SizedBox(width: 15.0),
          ButtonActions("Desconectar\n       todo", 3, data),
        ],
      ),
    );
  }
}