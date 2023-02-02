import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';

class WarningMessage extends StatefulWidget {
  String title;
  final Color col;

  WarningMessage(  
    this.title, 
    this.col,
  );

  @override
  State<WarningMessage> createState() => _WarningMessageState();
}

class _WarningMessageState extends State<WarningMessage> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(
        color: widget.col,
        fontSize: 24.0,
      )
    );
  }
}

Future<void> showMessage(BuildContext context) async {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: const Text(
          '\nNo hay conexion por Wi-Fi con el dispositivo',
          style: TextStyle(
            fontSize: 20,
          ),
        )
      ),
      action: SnackBarAction(label: 'CERRAR', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

WarningMessage? statusMessage(ProviderData data) {
  if (data.isConnect == true){
    if(data.ozoneValuePPM > 0.0){
      if((data.takeMeasure == false && data.ozone == true) || (data.takeMeasure == true && data.ozone == true)){
        return WarningMessage("Peligro Ozono En El Ambiente", Colors.red);
      }
      else{
        return WarningMessage("Peligro Ozono En El Ambiente", Colors.red);
      }
    }
    else if(data.ozoneValuePPM <= 0.0){
      if(data.takeMeasure == false){
        return WarningMessage("Peligro Ozono En El Ambiente", Colors.red);
      }
      else{
        if (data.ozone == false){
          return WarningMessage("Ambiente Seguro", Colors.green);
        }
        else{
          return WarningMessage("Peligro Ozono En El Ambiente", Colors.red);
        }
      }
    }
    else{
      return WarningMessage("", Colors.black);
    }
  }
  else{
    return WarningMessage("", Colors.black);
  }
}