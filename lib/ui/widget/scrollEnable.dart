import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';

class ScrollEnable extends StatefulWidget {

  ProviderData data;

  ScrollEnable(
    this.data,
  );

  @override
  State<ScrollEnable> createState() => _ScrollEnableState();
}

class _ScrollEnableState extends State<ScrollEnable> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: widget.data.scrolling,
            onChanged: (bool? value) {
              widget.data.scrolling = value;
            },
          ),
          const Text("desplazar"),
        ],
      ),
    );
  }
}