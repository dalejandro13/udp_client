import 'package:flutter/material.dart';

// class WarningMessage extends StatelessWidget {

//   String title;
//   int col;

//   // ignore: use_key_in_widget_constructors
//   WarningMessage({
//     this.title = "", 
//     this.col = 0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: TextStyle(
//         color: (col == 1) ? Color.green : Colors.red,
//         fontSize: 24.0,
//       )
//     );
//   }
// }

class WarningMessage extends StatefulWidget {
  String title;
  final Color col;

  WarningMessage({
    Key? key,  
    this.title = "", 
    this.col = Colors.black,
  }) : super(key: key);

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
