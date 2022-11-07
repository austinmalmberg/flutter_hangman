import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '_game_over_modal.dart';
import '_hud.dart';
import '_keyboard.dart';
import '_state_notifier.dart';

class HangmanScreen extends StatelessWidget {
  const HangmanScreen({super.key});

  Future<void> _loadWordlist(BuildContext context) async {
    File file = File('assets/wordlist.txt');
    Stream<String> lines =
        file.openRead().transform(utf8.decoder).transform(const LineSplitter());

    GameState state = Provider.of<GameState>(context, listen: false);
    state.wordlist = await lines.toList();
    state.reset();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameState>(
      create: (context) => GameState(wrongAllowed: 5),
      builder: (context, _) => Scaffold(
        body: FutureBuilder(
          future: _loadWordlist(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'Loading...',
                      textScaleFactor: 3.0,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: const <Widget>[
                    Expanded(
                      child: HUD(),
                    ),
                    Keyboard(),
                  ],
                ),
                const Positioned(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                  child: GameOverModalBuilder(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
