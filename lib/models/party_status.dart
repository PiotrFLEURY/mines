enum PartyStatus {
  playing,
  win,
  loose,
  cheat,
}

extension PartyStatusString on PartyStatus {
  String asText() {
    switch (this) {
      case PartyStatus.playing:
        return 'Playing';
      case PartyStatus.win:
        return 'Winner';
      case PartyStatus.loose:
        return 'Looser';
      case PartyStatus.cheat:
        return 'Cheater';
    }
  }
}
