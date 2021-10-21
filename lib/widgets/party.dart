import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mines/controlers/sound_controller.dart';
import 'package:mines/models/case_element.dart';
import 'package:mines/providers/party_provider.dart';
import 'package:mines/services/preferences.dart';
import 'package:mines/widgets/hint.dart';
import 'package:mines/widgets/party_menu.dart';
import 'package:mines/widgets/square.dart';
import 'package:mines/widgets/toolbar.dart';
import 'package:provider/provider.dart';

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
  final SoundController _soundController = SoundController();

  Orientation _orientation = Orientation.portrait;

  @override
  void dispose() {
    _soundController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _soundController.playMusic();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Preferences>(
          create: (context) => Preferences(),
        ),
        ChangeNotifierProvider(
          create: (_) => PartyProvider()..reset(),
        ),
      ],
      child: Consumer<PartyProvider>(builder: (context, provider, _) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation != _orientation) {
              _orientation = orientation;
              Future.delayed(
                const Duration(seconds: 1),
                context.read<PartyProvider>().reset,
              );
            }
            return Material(
              child: Stack(
                children: [
                  Column(
                    children: [
                      PartyToolbar(
                        height: toolbarHeight,
                        soundEnabled:
                            context.watch<Preferences>().isSoundEnabled,
                        onToggleSound: () {
                          _toggleSound(context);
                        },
                      ),
                      Expanded(
                        child: Builder(builder: (context) {
                          return Table(
                            columnWidths: const {
                              0: FlexColumnWidth(),
                              1: FlexColumnWidth(),
                              2: FlexColumnWidth(),
                              3: FlexColumnWidth(),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: _buildRows(provider),
                          );
                        }),
                      ),
                    ],
                  ),
                  PartyMenu(
                    status: context.watch<PartyProvider>().status,
                    onRestart: () {
                      PartyProvider provider = context.read<PartyProvider>();
                      provider.difficulty = 0;
                      provider.deathCount = 0;
                      provider.reset();
                    },
                    onTryAgain: context.read<PartyProvider>().reset,
                  ),
                  const PartyHint(),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  List<TableRow> _buildRows(PartyProvider provider) {
    return List.generate(
      provider.caseCount ~/ provider.columnCount,
      (rowIndex) => TableRow(
        children: _buildColumns(provider, rowIndex),
      ),
    );
  }

  List<Widget> _buildColumns(PartyProvider provider, int rowIndex) {
    return List.generate(
      provider.columnCount,
      (columnIndex) {
        CaseElement caseElement =
            provider.values[rowIndex * provider.columnCount + columnIndex];
        return Square(
          width: widget.width / provider.columnCount,
          height: (widget.height - toolbarHeight) /
              (provider.caseCount / provider.columnCount),
          element: caseElement,
          onReveal: () => _revealCase(provider, caseElement),
        );
      },
    );
  }

  _revealCase(PartyProvider provider, CaseElement caseElement) {
    _soundController.playClic();
    if (caseElement.value == 1) {
      _soundController.playExplosion();
    }
    provider.refresh();
  }

  _toggleSound(BuildContext context) {
    Preferences preferences = context.read<Preferences>();
    preferences.setSoundEnabled(!preferences.isSoundEnabled);
    _soundController.toggleSound(preferences.isSoundEnabled);
  }
}
