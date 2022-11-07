import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '_state_notifier.dart';

/// Widget containing the [HangmanWidget] and [GuessRow].
class HUD extends StatelessWidget {
  const HUD({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        Expanded(
          child: HangmanWidget(),
        ),
        GuessRow(),
      ],
    );
  }
}

class GuessRow extends StatelessWidget {
  const GuessRow({super.key});

  @override
  Widget build(BuildContext context) {
    String word = context.select<GameState, String>((state) => state.word);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        word.length,
        (index) => GuessTile(index: index),
      ),
    );
  }
}

class GuessTile extends StatelessWidget {
  final int index;

  const GuessTile({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String letter = Provider.of<GameState>(context, listen: false).word[index];

    bool guessed =
        context.select<GameState, bool>((state) => state.letters[letter]!);

    return SizedBox.square(
      dimension: 60.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 4.0),
          ),
        ),
        child: guessed
            ? Center(
                child: Text(
                letter.toUpperCase(),
                textScaleFactor: 2.0,
              ))
            : null,
      ),
    );
  }
}

class HangmanWidget extends StatelessWidget {
  const HangmanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    int wrong = context.select<GameState, int>((state) => state.wrong);

    return CustomPaint(
      foregroundPainter: HangmanPainter(wrong: wrong),
      size: const Size(360.0, 480.0),
    );
  }
}

class HangmanPainter extends CustomPainter {
  final int wrong;
  final Paint _paint;
  HangmanPaintReferences? _ref;

  HangmanPainter({required this.wrong})
      : _paint = Paint()
          ..color = Colors.black
          ..strokeWidth = 8.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

  HangmanPaintReferences get _r => _ref!;

  @override
  void paint(Canvas canvas, Size size) {
    if (_ref == null || _ref!.size != size) {
      _ref = HangmanPaintReferences(size);
    }

    _paintPlatform(canvas, size);

    if (wrong > 0) _paintHead(canvas, size);
    if (wrong > 1) _paintBody(canvas, size);
    if (wrong > 2) _paintRightArm(canvas, size);
    if (wrong > 3) _paintLeftArm(canvas, size);
    if (wrong > 4) _paintRightLeg(canvas, size);
    if (wrong > 5) _paintLeftLeg(canvas, size);
    if (wrong > 6) {
      throw UnimplementedError(
          'Current implementation does not support more than 6 wrong answers');
    }
  }

  void _paintPlatform(Canvas canvas, Size size) {
    // stage
    canvas.drawLine(_r.stageStart, _r.stageEnd, _paint);

    // pillar
    canvas.drawPoints(
        PointMode.polygon,
        <Offset>[
          _r.stageMidpoint,
          _r.pillarTop,
          _r.beamEnd,
          _r.nooseEnd,
        ],
        _paint);
  }

  void _paintHead(Canvas canvas, Size size) {
    canvas.drawCircle(_r.headCenter, _r.headRadius, _paint);
  }

  void _paintBody(Canvas canvas, Size size) {
    canvas.drawLine(_r.neck, _r.hip, _paint);
  }

  void _paintRightArm(Canvas canvas, Size size) {
    canvas.drawLine(_r.shoulder, _r.rightHand, _paint);
  }

  void _paintLeftArm(Canvas canvas, Size size) {
    canvas.drawLine(_r.shoulder, _r.leftHand, _paint);
  }

  void _paintRightLeg(Canvas canvas, Size size) {
    canvas.drawLine(_r.hip, _r.rightLeg, _paint);
  }

  void _paintLeftLeg(Canvas canvas, Size size) {
    canvas.drawLine(_r.hip, _r.leftLeg, _paint);
  }

  @override
  bool shouldRepaint(covariant HangmanPainter oldDelegate) =>
      wrong != oldDelegate.wrong;
}

class HangmanPaintReferences {
  final Size size;

  HangmanPaintReferences(this.size);

  // Structure
  double get stageMidpointX =>
      stageStart.dx + (stageEnd.dx - stageStart.dx) / 2;
  double get stageLength => stageEnd.dx - stageStart.dx;
  double get beamLength => stageLength * 0.8;

  Offset get stageStart => Offset(size.width * 0.15, size.height * 0.9);
  Offset get stageEnd => stageStart.translate(size.width * 0.4, 0.0);
  Offset get stageMidpoint => Offset(stageMidpointX, stageStart.dy);
  Offset get pillarTop => stageMidpoint.translate(0.0, -size.height * 0.7);
  Offset get beamEnd => pillarTop.translate(beamLength, 0.0);
  Offset get nooseEnd => beamEnd.translate(0.0, size.height * 0.1);

  // Hangman head
  double get headRadius => size.height * 0.06;
  Offset get headCenter => nooseEnd.translate(0.0, headRadius);

  // Hangman torso
  double get torsoLength => size.height * 0.15;
  Offset get neck => nooseEnd.translate(0.0, headRadius * 2);
  Offset get hip => neck.translate(0.0, torsoLength);

  // Hangman arms
  Offset get shoulder => neck.translate(0.0, 20.0);
  double get handDy => size.height * 0.04;
  double get handDx => size.width * 0.08;
  Offset get rightHand => shoulder.translate(-handDx, handDy);
  Offset get leftHand => shoulder.translate(handDx, handDy);

  // Hangman legs
  double get footDy => size.height * 0.14;
  double get footDx => size.width * 0.04;
  Offset get rightLeg => hip.translate(-footDx, footDy);
  Offset get leftLeg => hip.translate(footDx, footDy);
}
