import 'package:flutter/material.dart';
import 'package:mines/models/party_status.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mines/services/preferences.dart';

class PartyMenu extends StatefulWidget {
  final PartyStatus status;
  final Function() onRestart;
  final Function() onTryAgain;

  const PartyMenu({
    Key? key,
    required this.status,
    required this.onRestart,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  State<PartyMenu> createState() => _PartyMenuState();
}

class _PartyMenuState extends State<PartyMenu> {
  late AudioPlayer player;

  @override
  void initState() {
    player = AudioPlayer();
    _playExplosition();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _playExplosition() async {
    bool soundEnabled = await Preferences.isSoundEnabled();
    if (soundEnabled) {
      await player
          .setAsset('assets/audio/mixkit-explosion-with-rocks-debris-1703.wav');
      player.play();
    }
  }

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
                if ([PartyStatus.loose, PartyStatus.cheat]
                    .contains(widget.status))
                  Image.asset(
                    'assets/images/explosion.png',
                    height: 256.0,
                  ),
                Text(
                  widget.status.asText(),
                  style: Theme.of(context).textTheme.headline3,
                ),
                ElevatedButton(
                  onPressed: widget.onRestart,
                  child: const Text('Restart'),
                ),
                if (widget.status != PartyStatus.cheat)
                  ElevatedButton(
                    onPressed: widget.onTryAgain,
                    child: const Text('Try again'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
