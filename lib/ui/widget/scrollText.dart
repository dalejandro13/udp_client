import 'package:flutter/material.dart';
import 'package:udp_client/bloc/providerData.dart';

class ScrollText extends StatefulWidget {
  ProviderData data;

  ScrollText(
    this.data,
  );

  @override
  State<ScrollText> createState() => _ScrollTextState();
}

class _ScrollTextState extends State<ScrollText> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(
          maxHeight: 100.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: widget.data.ctrl3!,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none
              ),
              keyboardType: TextInputType.multiline,
              readOnly: true,
              controller: widget.data.ctrl2,
              textInputAction: TextInputAction.newline,
              maxLines: null,
            ),
          ),
        ),
      ),
    );
  }
}