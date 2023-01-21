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
