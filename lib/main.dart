// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mines/widgets/party.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.app_title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.architectsDaughterTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Builder(
        builder: (context) {
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => Party(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            ),
          );
        },
      ),
    );
  }
}
