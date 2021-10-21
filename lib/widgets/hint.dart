import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mines/providers/party_provider.dart';
import 'package:provider/provider.dart';

class PartyHint extends StatelessWidget {
  const PartyHint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.read<PartyProvider>().hintValue <= 0
        ? Container()
        : LinearProgressIndicator(
            value: context.watch<PartyProvider>().progress,
            minHeight: 8.0,
          );
  }
}
