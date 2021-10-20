import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mines/models/case_element.dart';
import 'package:mines/models/party_state.dart';
import 'package:mines/models/party_status.dart';
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
  int _difficulty = 0;
  Orientation _orientation = Orientation.portrait;

  @override
  void initState() {
    _reset();
    super.initState();
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
                        Text('Status: ${state.status.asText()} '),
                        ElevatedButton(
                          child: const Text('reset'),
                          onPressed: _reset,
                        ),
                        Text('Score: ${state.score}'),
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      int columnCount = _difficulty == 0 ? 2 : 4;
                      return Table(
                        border: TableBorder.all(color: Colors.black),
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
                                onReveal: _refresh,
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
                        });
                        _reset();
                      },
                      onTryAgain: _reset,
                      onRageQuit: closeApp,
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

      bool loose = values
          .where(
            (element) => element.isRevealed && element.value != 0,
          )
          .isNotEmpty;
      bool win =
          state.score == values.where((element) => element.value == 0).length;

      state.status = loose
          ? PartyStatus.loose
          : win
              ? PartyStatus.win
              : PartyStatus.playing;

      if (loose) {
        values.where((element) => element.value == 1).forEach((element) {
          element.reveal();
        });
      }
      if (win) {
        _difficulty = min(_difficulty + 1, _possibleCounts.length - 1);
        _reset();
      }
    });
  }

  void _reset() {
    setState(() {
      state.reset();
      int elementCount = _possibleCounts[_difficulty];
      values.clear();
      // Generate 12 random values between 0 and 1
      for (var i = 0; i < elementCount; i++) {
        values.add(CaseElement(Random().nextInt(2)));
      }
      _revealBooms();
      Future.delayed(const Duration(seconds: 3), () {
        _hideBooms();
        _refresh();
      });
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
