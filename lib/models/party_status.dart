import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PartyStatus {
  playing,
  pause,
  win,
  loose,
  cheat,
}

extension PartyStatusString on PartyStatus {
  String asText(BuildContext context) {
    switch (this) {
      case PartyStatus.playing:
        return AppLocalizations.of(context)!.party_status_playing;
      case PartyStatus.pause:
        return AppLocalizations.of(context)!.party_status_paused;
      case PartyStatus.win:
        return AppLocalizations.of(context)!.party_status_won;
      case PartyStatus.loose:
        return AppLocalizations.of(context)!.party_status_loosed;
      case PartyStatus.cheat:
        return AppLocalizations.of(context)!.party_status_cheater;
    }
  }
}
