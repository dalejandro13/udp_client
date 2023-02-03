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
  scaffold.removeCurrentSnackBar(); //con esto se cierra el snackbar actual y se abre nuevamente
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
      if(data.takeMeasure == false && data.ozone == true){
        return WarningMessage("Peligro Ozono En El Ambiente", Colors.red);
      }
      else if (data.takeMeasure == true && data.ozone == false) {
        return WarningMessage("Ambiente Seguro", Colors.green);
      }
      else{
        return WarningMessage("Peligro Ozono En El Ambiente", Colors.red);
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

Future<void> messageBox(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Center(child: Text("Controlador Ozono")),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 70.0,
            width: 70.0,
            child: Image.asset('assets\\images\\iconFlexo.png')
          ),
          const Text("Flexolumens\nderechos reservados\n2022 - 2023\n\nversion 1.0.0"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () { Navigator.of(ctx).pop(); },
          child: const Center(
            child: Text(
              "OK",
              style: TextStyle(
                fontSize: 17.0,
              ),
            )
          ),
        ),
      ],
    ),
  );
}