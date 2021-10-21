enum PartyStatus {
  playing,
  pause,
  win,
  loose,
  cheat,
}

extension PartyStatusString on PartyStatus {
  String asText() {
    switch (this) {
      case PartyStatus.playing:
        return 'Playing';
      case PartyStatus.pause:
        return 'Pause';
      case PartyStatus.win:
        return 'Winner';
      case PartyStatus.loose:
        return 'Looser';
      case PartyStatus.cheat:
        return 'Cheater';
    }
  }
}
