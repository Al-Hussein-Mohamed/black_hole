import 'package:black_hole/controllers/game_cubit.dart';
import 'package:black_hole/core/configuration/config.dart';
import 'package:black_hole/core/const/palette.dart';
import 'package:black_hole/models/hole_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_animated_widget.dart';

class ScoreAndInstructionsWidget extends StatelessWidget {
  const ScoreAndInstructionsWidget({super.key, required AnimationController controller})
    : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          if (state.status != Status.playing) return _ScoreBoard();
          return CustomAnimatedWidget(
            animation: CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
            ),
            child: const _Instructions(),
          );
        },
      ),
    );
  }
}

class _Instructions extends StatelessWidget {
  const _Instructions();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.player == Player.first ? "Player 1" : "Player 2",
              style: TextStyle(
                color: state.player == Player.first ? Palette.player1 : Palette.player2,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: state.player == Player.first ? Palette.player1 : Palette.player2,
                // color: Colors.grey[900],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${state.currentValue}',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScoreBoard extends StatelessWidget {
  const _ScoreBoard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) {
        if (previous.status != current.status) return true;
        if (previous.score1 != current.score1) return true;
        if (previous.score2 != current.score2) return true;
        return false;
      },
      builder: (context, state) {
        return AnimatedOpacity(
          duration: Config.shortAnimationDuration,
          opacity: state.status == Status.playing ? 0 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _scoreItem("Player 1", state.score1, Palette.player1),
              _scoreItem("Player 2", state.score2, Palette.player2),
            ],
          ),
        );
      },
    );
  }

  Widget _scoreItem(String title, int score, Color color) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: score.toDouble()),
      duration: Config.calcResultDuration,
      builder: (context, value, child) {
        return Column(
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 40, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  value.round().toString(),
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
