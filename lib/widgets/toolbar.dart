import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mines/providers/party_provider.dart';
import 'package:provider/provider.dart';

class PartyToolbar extends StatelessWidget {
  final double height;

  const PartyToolbar({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              context.read<PartyProvider>().pause();
            },
            icon: const Icon(Icons.menu),
          ),
          Text(
            AppLocalizations.of(context)!.score(
              context.watch<PartyProvider>().score,
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            AppLocalizations.of(context)!.level(
              context.watch<PartyProvider>().difficulty + 1,
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          if (kDebugMode)
            DropdownButton<int>(
              items: List.generate(
                context.read<PartyProvider>().possibleCounts.length,
                (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Text(index.toString()),
                ),
              ),
              value: context.watch<PartyProvider>().difficulty,
              onChanged: (value) {
                final PartyProvider provider = context.read<PartyProvider>();
                provider.difficulty = value!;
                provider.reset();
              },
            ),
          Text(
            AppLocalizations.of(context)!.death_count(
              context.watch<PartyProvider>().deathCount,
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
