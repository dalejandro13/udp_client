import 'package:flutter/material.dart';

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
