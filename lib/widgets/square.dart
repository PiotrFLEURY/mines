import 'package:flutter/material.dart';
import 'package:mines/models/case_element.dart';

class Square extends StatelessWidget {
  final CaseElement element;
  final double width;
  final double height;
  final Function() onReveal;

  const Square({
    Key? key,
    required this.width,
    required this.height,
    required this.element,
    required this.onReveal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: element.isRevealed
              ? element.value == 0
                  ? Colors.black
                  : Colors.red
              : Colors.grey,
          width: 2.0,
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: element.isRevealed
          ? element.value == 0
              ? Image.asset('assets/images/check.png')
              : Image.asset('assets/images/boom.png')
          : GestureDetector(
              onTap: () {
                element.reveal();
                onReveal();
              },
              child: Image.asset('assets/images/question.png'),
            ),
    );
  }
}
