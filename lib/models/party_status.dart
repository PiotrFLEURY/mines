enum PartyStatus {
  playing,
  win,
  loose,
}

extension PartyStatusString on PartyStatus {
  String asText() {
    switch (this) {
      case PartyStatus.playing:
        return 'Playing';
      case PartyStatus.win:
        return 'Win';
      case PartyStatus.loose:
        return 'Loose';
    }
  }
}
