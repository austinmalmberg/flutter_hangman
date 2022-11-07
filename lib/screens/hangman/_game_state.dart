import 'dart:math';

import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  final int wrongAllowed;
  final Map<String, bool> letters;

  RunningState runState = RunningState.normal;
  List<String>? wordlist;
  String word;
  int wrong = 0;

  GameState({required this.wrongAllowed, this.wordlist})
      : word = _getRandomWord(wordlist) ?? 'hangman',
        letters = _initLetters();

  static Map<String, bool> _initLetters() {
    String chars = 'qwertyuiop'
        'asdfghjkl'
        'zxcvbnm';

    return {for (String char in chars.characters) char: false};
  }

  void guess(String letter) {
    letters[letter] = true;

    if (!letterSet().contains(letter)) {
      ++wrong;

      if (isLoser()) runState = RunningState.defeat;
    } else if (isWinner()) {
      runState = RunningState.victory;
    }

    notifyListeners();
  }

  Set<String> letterSet() => word.characters.toSet();
  int get attemptsRemaining => wrongAllowed - wrong;

  bool isWinner() => letterSet().every((letter) => letters[letter]! == true);
  bool isLoser() => wrong > wrongAllowed;

  void reset() {
    word = _getRandomWord(wordlist) ?? 'hangman';
    wrong = 0;
    letters.forEach((key, value) => letters[key] = false);
    runState = RunningState.normal;

    notifyListeners();
  }

  static String? _getRandomWord(wordlist,
      [Random? rng, int min = 6, int max = 12]) {
    if (wordlist == null) return null;

    rng ??= Random();

    Iterable<String> qualifiedWords =
        wordlist!.where((word) => word.length >= min && word.length <= max);

    return qualifiedWords.elementAt(rng.nextInt(qualifiedWords.length));
  }
}

enum RunningState {
  normal,
  victory,
  defeat,
}
