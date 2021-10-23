import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mines/models/case_element.dart';
import 'package:mines/models/party_state.dart';
import 'package:mines/models/party_status.dart';

class PartyProvider extends ChangeNotifier {
  Orientation orientation = Orientation.portrait;
  final PartyState state = PartyState();
  final List<CaseElement> values = [];
  final List<int> possibleCounts = [
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
    44,
    48,
  ];

  final double hintTimer = 2000;
  double hintValue = 0;
  int difficulty = 0;
  int deathCount = 0;

  void pause() {
    state.status = PartyStatus.pause;
    notifyListeners();
  }

  void resume() {
    state.status = PartyStatus.playing;
    notifyListeners();
  }

  int get score => state.score;

  bool get playing => state.status == PartyStatus.playing;

  PartyStatus get status => state.status;

  int get caseCount => possibleCounts[difficulty];

  int get columnCount => difficulty == 0 ? 2 : 4;

  void refresh() {
    state.score = values
        .where(
          (element) => element.isRevealed && element.value == 0,
        )
        .length;

    final bool loose =
        values.any((element) => element.isRevealed && element.value != 0);

    final bool win =
        state.score == values.where((element) => element.value == 0).length;

    final bool cheat = state.status == PartyStatus.cheat ||
        values.any((element) => element.isRevealed) && hintValue > 0;

    if (cheat) {
      state.status = PartyStatus.cheat;
    } else if (loose) {
      state.status = PartyStatus.loose;
      deathCount++;
      values.where((element) => element.value == 1).forEach((element) {
        element.reveal();
      });
    } else if (win) {
      state.status = PartyStatus.win;
      difficulty = min(difficulty + 1, possibleCounts.length - 1);
      reset();
    } else {
      state.status = PartyStatus.playing;
    }
    notifyListeners();
  }

  void reset() {
    hintValue = hintTimer;
    state.reset();
    final int elementCount = possibleCounts[difficulty];
    values.clear();
    // Generate random values between 0 and 1
    for (var i = 0; i < elementCount; i++) {
      values.add(CaseElement(Random().nextInt(2)));
    }
    if (values.every((element) => element.value == 0)) {
      values[0].value = 1;
    }
    _revealBooms();

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      hintValue = hintValue - 16;
      if (hintValue <= 0) {
        timer.cancel();
        _hideBooms();
      }

      notifyListeners();
    });

    notifyListeners();
  }

  void _revealBooms() {
    values.where((element) => element.value == 1).forEach((element) {
      element.reveal();
    });
  }

  void _hideBooms() {
    values.where((element) => element.value == 1).forEach((element) {
      element.hide();
    });
    refresh();
  }

  double get progress => max(hintValue / hintTimer, 0);
}
