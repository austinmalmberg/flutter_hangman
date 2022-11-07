import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '_state_notifier.dart';

/// The victory or defeat modal when the game ends and a shrinked box otherwise.
class GameOverModalBuilder extends StatelessWidget {
  const GameOverModalBuilder({super.key});
  static const double ar = 4 / 2;

  @override
  Widget build(BuildContext context) {
    RunningState runState =
        context.select<GameState, RunningState>((state) => state.runState);

    switch (runState) {
      case RunningState.normal:
        return const SizedBox.shrink();
      case RunningState.victory:
        return const AspectRatio(
          aspectRatio: ar,
          child: VictoryModal(),
        );
      case RunningState.defeat:
        return const AspectRatio(
          aspectRatio: ar,
          child: TryAgainModal(),
        );
      default:
        throw UnimplementedError();
    }
  }
}

class GameOverModal extends StatelessWidget {
  const GameOverModal({
    super.key,
    required this.body,
    required this.resetButtonText,
    this.color,
    this.gradient,
  });

  final Widget body;
  final String resetButtonText;
  final Gradient? gradient;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: gradient,
        color: color,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: body,
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<GameState>(context, listen: false).reset();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text(resetButtonText),
          ),
        ],
      ),
    );
  }
}

class VictoryModal extends StatelessWidget {
  const VictoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const GameOverModal(
      body: Center(
        child: FittedBox(
          child: Text(
            'You win!',
            textScaleFactor: 6.0,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      resetButtonText: 'Play Again',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.indigo,
          Colors.cyan,
          Colors.blue,
        ],
      ),
    );
  }
}

class TryAgainModal extends StatelessWidget {
  const TryAgainModal({super.key});

  @override
  Widget build(BuildContext context) {
    String word = Provider.of<GameState>(context, listen: false).word;

    return GameOverModal(
      body: Column(
        children: <Widget>[
          const FittedBox(
            child: Text(
              'You win!',
              textScaleFactor: 6.0,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          FittedBox(
            child: Text(
              'The word was "$word"',
              textScaleFactor: 1.5,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      resetButtonText: 'Try Again',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.red,
          Colors.amber,
        ],
      ),
    );
  }
}
