class CaseElement {
  int value;
  bool isRevealed;

  CaseElement(
    this.value, {
    this.isRevealed = false,
  });

  void reveal({bool user = false}) {
    isRevealed = true;
    if (user && value == 1) {
      explode();
    }
  }

  void hide() {
    isRevealed = false;
  }

  void explode() {
    value = 2;
  }
}
