import 'package:mines/models/party_status.dart';

class PartyState {
  PartyStatus status;
  int score;

  PartyState({
    this.status = PartyStatus.playing,
    this.score = 0,
  });

  reset() {
    status = PartyStatus.playing;
    score = 0;
  }
}
