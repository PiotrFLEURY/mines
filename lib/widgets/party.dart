import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mines/models/case_element.dart';
import 'package:mines/models/party_state.dart';
import 'package:mines/models/party_status.dart';
import 'package:mines/services/preferences.dart';
import 'package:mines/widgets/party_menu.dart';
import 'package:mines/widgets/square.dart';

class Party extends StatefulWidget {
  final double width;
  final double height;

  const Party({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> {
  final toolbarHeight = 64.0;
  final List<CaseElement> values = [];
  final PartyState state = PartyState();
  final List<int> _possibleCounts = [
    4,
    8,
    12,
    16,
    20,
    24,
    28,
    32,
    36,
    40,
  ];

  final double hintTimer = 2000;
  double hintValue = 0;
  int _difficulty = 0;
  Orientation _orientation = Orientation.portrait;
  int _deathCount = 0;

  late AudioPlayer musicPlayer;
  late AudioPlayer effectPlayer;

  bool _soundEnabled = true;

  @override
  void dispose() {
    musicPlayer.dispose();
    effectPlayer.dispose();
    super.dispose();
  }

  void _playClic() async {
    if (_soundEnabled) {
      await effectPlayer
          .setAsset('assets/audio/mixkit-mouse-click-close-1113.wav');
      effectPlayer.play();
    }
  }

  void _playMusic() async {
    await musicPlayer.setAsset('assets/audio/mixkit-vertigo-597(2).mp3');
    musicPlayer.play();
  }

  @override
  void initState() {
    _reset();
    musicPlayer = AudioPlayer();
    effectPlayer = AudioPlayer();
    super.initState();
    _playMusic();
  }

  void _toggleSound() {
    setState(() {
      _soundEnabled = !_soundEnabled;
    });
    Preferences.setSoundEnabled(_soundEnabled);
    if (_soundEnabled) {
      musicPlayer.play();
    } else {
      musicPlayer.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation != _orientation) {
          _orientation = orientation;
          Future.delayed(const Duration(seconds: 1), _reset);
        }
        return Material(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: toolbarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.restart_alt,
                            color: Colors.red,
                          ),
                          onPressed: _reset,
                        ),
                        IconButton(
                          onPressed: _toggleSound,
                          icon: Icon(
                            _soundEnabled ? Icons.volume_up : Icons.volume_off,
                          ),
                        ),
                        Text(
                          'Score: ${state.score}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Level: ${_difficulty + 1}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        DropdownButton<int>(
                          items: List.generate(
                            _possibleCounts.length,
                            (index) => DropdownMenuItem<int>(
                              child: Text(index.toString()),
                              value: index,
                            ),
                          ),
                          value: _difficulty,
                          onChanged: (value) {
                            setState(() {
                              _difficulty = value!;
                              _reset();
                            });
                          },
                        ),
                        Text(
                          'Death: $_deathCount',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      int columnCount = _difficulty == 0 ? 2 : 4;
                      return Table(
                        columnWidths: const {
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                          2: FlexColumnWidth(),
                          3: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: List.generate(
                          _possibleCounts[_difficulty] ~/ columnCount,
                          (rowIndex) => TableRow(
                            children: List.generate(
                              columnCount,
                              (columnIndex) => Square(
                                width: widget.width / columnCount,
                                height: (widget.height - toolbarHeight) /
                                    (_possibleCounts[_difficulty] /
                                        columnCount),
                                element: values[
                                    rowIndex * columnCount + columnIndex],
                                onReveal: () {
                                  _playClic();
                                  _refresh();
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              state.status == PartyStatus.playing
                  ? Container()
                  : PartyMenu(
                      status: state.status,
                      onRestart: () {
                        setState(() {
                          _difficulty = 0;
                          _deathCount = 0;
                        });
                        _reset();
                      },
                      onTryAgain: _reset,
                      onRageQuit: closeApp,
                    ),
              hintValue <= 0
                  ? Container()
                  : LinearProgressIndicator(
                      value: max(hintValue / hintTimer, 0),
                      minHeight: 8.0,
                    ),
            ],
          ),
        );
      },
    );
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      exit(0);
    }
  }

  void _refresh() {
    setState(() {
      state.score = values
          .where(
            (element) => element.isRevealed && element.value == 0,
          )
          .length;

      bool loose =
          values.any((element) => element.isRevealed && element.value != 0);

      bool win =
          state.score == values.where((element) => element.value == 0).length;

      bool cheat = state.status == PartyStatus.cheat ||
          values.any((element) => element.isRevealed) && hintValue > 0;

      if (cheat) {
        state.status = PartyStatus.cheat;
      } else if (loose) {
        state.status = PartyStatus.loose;
        _deathCount++;
        values.where((element) => element.value == 1).forEach((element) {
          element.reveal();
        });
      } else if (win) {
        state.status = PartyStatus.win;
        _difficulty = min(_difficulty + 1, _possibleCounts.length - 1);
        _reset();
      } else {
        state.status = PartyStatus.playing;
      }
    });
  }

  void _reset() {
    setState(() {
      hintValue = hintTimer;
      state.reset();
      int elementCount = _possibleCounts[_difficulty];
      values.clear();
      // Generate random values between 0 and 1
      for (var i = 0; i < elementCount; i++) {
        values.add(CaseElement(Random().nextInt(2)));
      }
      if (values.every((element) => element.value == 0)) {
        values[0].value = 1;
      }
      _revealBooms();
    });
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        hintValue = hintValue - 16;
      });
      if (hintValue <= 0) {
        timer.cancel();
        _hideBooms();
        _refresh();
      }
    });
  }

  _revealBooms() {
    values.where((element) => element.value == 1).forEach((element) {
      element.reveal();
    });
  }

  _hideBooms() {
    values.where((element) => element.value == 1).forEach((element) {
      element.hide();
    });
  }
}
