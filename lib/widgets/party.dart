// ignore_for_file: require_trailing_commas

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mines/models/case_element.dart';
import 'package:mines/providers/party_provider.dart';
import 'package:mines/widgets/hint.dart';
import 'package:mines/widgets/party_menu.dart';
import 'package:mines/widgets/square.dart';
import 'package:mines/widgets/toolbar.dart';
import 'package:provider/provider.dart';

class Party extends StatelessWidget {
  final double width;
  final double height;
  static const toolbarHeight = 64.0;

  const Party({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PartyProvider()..reset(),
        ),
      ],
      child: Consumer<PartyProvider>(builder: (context, provider, _) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation != provider.orientation) {
              provider.orientation = orientation;
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
                      const PartyToolbar(height: toolbarHeight),
                      Expanded(
                        child: Builder(
                          builder: (context) {
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
                          },
                        ),
                      ),
                    ],
                  ),
                  PartyMenu(
                    status: context.watch<PartyProvider>().status,
                    onRestart: () {
                      final PartyProvider provider =
                          context.read<PartyProvider>();
                      provider.difficulty = 0;
                      provider.deathCount = 0;
                      provider.reset();
                    },
                    onTryAgain: context.read<PartyProvider>().reset,
                  ),
                  PartyHint(
                    value: context.read<PartyProvider>().hintValue,
                  ),
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
        final CaseElement caseElement =
            provider.values[rowIndex * provider.columnCount + columnIndex];
        return Square(
          width: width / provider.columnCount,
          height: (height - toolbarHeight) /
              (provider.caseCount / provider.columnCount),
          element: caseElement,
          onReveal: () => provider.refresh(),
        );
      },
    );
  }
}
