import 'package:flutter/material.dart';
import 'package:mines/models/party_status.dart';

class PartyMenu extends StatelessWidget {
  final PartyStatus status;
  final Function() onRestart;
  final Function() onTryAgain;
  final Function() onRageQuit;

  const PartyMenu({
    Key? key,
    required this.status,
    required this.onRestart,
    required this.onTryAgain,
    required this.onRageQuit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Menu',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Colors.green),
                ),
                Text(
                  'you ' + status.asText(),
                  style: Theme.of(context).textTheme.headline3,
                ),
                ElevatedButton(
                  onPressed: onRestart,
                  child: const Text('Restart'),
                ),
                ElevatedButton(
                  onPressed: onTryAgain,
                  child: const Text('Try again'),
                ),
                ElevatedButton(
                  onPressed: onRageQuit,
                  child: const Text('Rage quit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
