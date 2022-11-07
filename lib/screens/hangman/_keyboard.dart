import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '_state_notifier.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({super.key});

  Widget _asKeyboardRow(String chars) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _asKeys(chars),
      );

  List<Widget> _asKeys(String chars) =>
      chars.characters.map((ch) => KeyboardKey(letter: ch)).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _asKeyboardRow('qwertyuiop'),
          _asKeyboardRow('asdfghjkl'),
          _asKeyboardRow('zxcvbnm'),
        ],
      ),
    );
  }
}

class KeyboardKey extends StatelessWidget {
  final String letter;

  const KeyboardKey({super.key, required this.letter});

  void _handleKeyPressed(BuildContext context) {
    GameState state = Provider.of<GameState>(context, listen: false);

    if (state.runState == RunningState.normal) {
      state.guess(letter);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool guessed =
        context.select<GameState, bool>((state) => state.letters[letter]!);

    return Container(
      width: 40.0,
      height: 40.0,
      margin: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: guessed ? null : () => _handleKeyPressed(context),
        child: Text(letter.toUpperCase()),
      ),
    );
  }
}
