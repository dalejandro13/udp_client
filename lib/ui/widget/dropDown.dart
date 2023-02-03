import 'package:flutter/material.dart';
import 'package:udp_client/ui/widget/warningMessage.dart';

class DropButton extends StatelessWidget {
  const DropButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          dropdownColor: Colors.blue,
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          items: <String>['Acerca de ...'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) async {
            await messageBox(context);
          }),
      ),
    );
  }
}