import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mines/providers/party_provider.dart';
import 'package:provider/provider.dart';

class PartyHint extends StatelessWidget {
  final double value;
  const PartyHint({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return value <= 0
        ? Container()
        : LinearProgressIndicator(
            value: context.watch<PartyProvider>().progress,
            minHeight: 8.0,
          );
  }
}
