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
  final List<double> _possibleHeights = [
    128.0,
    96.0,
    80.0,
    64.0,
    48.0,
  ];
  int _difficulty = 0;
  late double elementHeight;
  Orientation _orientation = Orientation.portrait;

  @override
  void initState() {
    _reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _columns = _computeColumnCount();
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
                            _possibleHeights.length,
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
                    child: GridView.count(
                      crossAxisCount: _columns,
                      children: values.map((value) {
                        return Square(
                          element: value,
                          width: elementHeight,
                          height: elementHeight,
                          onReveal: _refresh,
                        );
                      }).toList(),
                    ),
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
        _difficulty = min(_difficulty + 1, _possibleHeights.length - 1);
        _reset();
      }
    });
  }

  void _reset() {
    setState(() {
      elementHeight = _possibleHeights[_difficulty];
      state.reset();
      int elementCount = _computeElementCount();
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

  int _computeColumnCount() {
    double screenWidth = widget.width;
    return (screenWidth / elementHeight).floor();
  }

  int _computeElementCount() {
    double screenWidth = widget.width;
    double screenHeight =
        widget.height - toolbarHeight; // remove toolbar height
    int rowCount = (screenHeight / elementHeight).floor();
    int columnCount = (screenWidth / elementHeight).floor();
    return rowCount * columnCount;
  }
}
