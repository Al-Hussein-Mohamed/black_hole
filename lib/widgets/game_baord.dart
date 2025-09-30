import 'package:black_hole/models/hole_model.dart';
import 'package:flutter/material.dart';

import 'animated_hole.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...HoleModel.holes.map((holes) => _Row(holes: holes, controller: controller)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.holes, required this.controller});

  final List<HoleModel> holes;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: holes.map((hole) => AnimatedHole(hole: hole, controller: controller)).toList(),
    );
  }
}
