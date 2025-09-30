import 'dart:math';

import 'package:black_hole/controllers/game_cubit.dart';
import 'package:black_hole/core/configuration/config.dart';
import 'package:black_hole/core/const/palette.dart';
import 'package:black_hole/models/hole_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_animated_widget.dart';

class AnimatedHole extends StatelessWidget {
  const AnimatedHole({super.key, required this.hole, required this.controller});

  final HoleModel hole;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final totalHoles = HoleModel.N;
    final holeIndex = hole.id - 1;

    final start = 0.4 + (0.6 * (holeIndex / totalHoles));
    final end = start + (0.6 / totalHoles) * 5;
    final interval = Interval(start.clamp(0.4, 1.0), end.clamp(0.4, 1.0), curve: Curves.easeOut);

    return CustomAnimatedWidget(
      animation: CurvedAnimation(parent: controller, curve: interval),
      child: _HoleWidget(hole),
    );
  }
}

class _HoleWidget extends StatelessWidget {
  const _HoleWidget(this.hole);

  final HoleModel hole;

  @override
  Widget build(BuildContext context) {
    final gameCubit = GameCubit.of(context);
    final row = HoleModel.position[hole.id][0];
    final col = HoleModel.position[hole.id][1];

    final screenWidth = MediaQuery.of(context).size.width;
    final holeSize = min<double>(100, (screenWidth - 100) / 6);

    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (oldState, newState) {
        final oldHole = oldState.holes[row][col];
        final newHole = newState.holes[row][col];
        if (oldHole.player != newHole.player) return true;
        if (oldState.status != newState.status) return true;
        if (oldState.adj.contains(hole.id) != newState.adj.contains(hole.id)) return true;
        return false;
      },

      builder: (context, state) {
        final currentHole = state.holes[hole.row][hole.col];

        Color color = switch (currentHole.player) {
          Player.none => Palette.secondary.withOpacity(0.5),
          Player.first => Palette.player1,
          Player.second => Palette.player2,
        };

        if (state.status != Status.playing && state.adj.contains(hole.id) == false) {
          color = color.withAlpha(50);
        }

        if (hole.id == state.blackHole) {
          color = Colors.black;
        }

        return GestureDetector(
          onTap: () => currentHole.player == Player.none ? gameCubit.check(hole.id) : null,
          child: AnimatedContainer(
            duration: Config.shortAnimationDuration,
            width: holeSize,
            height: holeSize,
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child:
                currentHole.player == Player.none
                    ? null
                    : Center(
                      child: Text(
                        '${currentHole.value}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
          ),
        );
      },
    );
  }
}
