import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.architectsDaughterTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Builder(builder: (context) {
        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => Party(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
          ),
        );
      }),
    );
  }
}
