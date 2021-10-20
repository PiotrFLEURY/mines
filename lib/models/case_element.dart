class CaseElement {
  int value;
  bool isRevealed;

  CaseElement(
    this.value, {
    this.isRevealed = false,
  });

  reveal() {
    isRevealed = true;
  }

  hide() {
    isRevealed = false;
  }
}
