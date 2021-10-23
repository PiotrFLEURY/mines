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
    return GestureDetector(
      onTap: () {
        if (element.isRevealed) return;
        element.reveal(user: true);
        onReveal();
      },
      child: Container(
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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: _content(),
        ),
      ),
    );
  }

  Widget _content() {
    return Image.asset(
      element.isRevealed ? revealedAsset() : 'assets/images/question.png',
      height: 48.0,
      width: 48.0,
    );
  }

  String revealedAsset() {
    switch (element.value) {
      case 0:
        return 'assets/images/check.png';

      case 1:
        return 'assets/images/mine.png';

      case 2:
        return 'assets/images/boom.png';

      default:
        return '';
    }
  }
}
