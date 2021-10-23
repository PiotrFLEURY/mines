import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mines/models/party_status.dart';
import 'package:mines/providers/party_provider.dart';
import 'package:provider/provider.dart';

class PartyMenu extends StatefulWidget {
  final PartyStatus status;
  final Function() onRestart;
  final Function() onTryAgain;

  const PartyMenu({
    Key? key,
    required this.status,
    required this.onRestart,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  State<PartyMenu> createState() => _PartyMenuState();
}

class _PartyMenuState extends State<PartyMenu> {
  @override
  Widget build(BuildContext context) {
    return context.read<PartyProvider>().playing
        ? Container()
        : Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(48),
            color: Colors.black.withOpacity(0.8),
            child: Center(
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(4.0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () =>
                              context.read<PartyProvider>().resume(),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.menu,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: Colors.green),
                      ),
                      if ([PartyStatus.loose, PartyStatus.cheat]
                          .contains(widget.status))
                        Image.asset(
                          'assets/images/explosion.png',
                          height: 256.0,
                        ),
                      Text(
                        widget.status.asText(context),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      ElevatedButton(
                        onPressed: widget.onRestart,
                        child: Text(
                          AppLocalizations.of(context)!.restart,
                        ),
                      ),
                      if (widget.status != PartyStatus.cheat)
                        ElevatedButton(
                          onPressed: widget.onTryAgain,
                          child: Text(
                            AppLocalizations.of(context)!.try_again,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
