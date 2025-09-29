import 'package:black_hole/core/configuration/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/game_status_cubit.dart';
import 'core/const/palette.dart';
import 'models/circle_model.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: const BoxDecoration(
    //     gradient: LinearGradient(
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: [Color(0xFF13102C), Color(0xFF20194B), Color(0xFF2C285D)],
    //     ),
    //   ),
    // );

    return Stack(
      children: [
        Positioned.fill(child: Container(color: Palette.base)),
        ...CircleModel.backgroundCircles.map((circle) => _CircleWidget(circle: circle)),
      ],
    );
  }
}

class _CircleWidget extends StatelessWidget {
  const _CircleWidget({required this.circle});

  final CircleModel circle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameStatusCubit, bool>(
      builder: (context, gameOn) {
        return AnimatedPositioned(
          top: circle.positions[gameOn ? 1 : 0][Direction.top],
          left: circle.positions[gameOn ? 1 : 0][Direction.left],
          right: circle.positions[gameOn ? 1 : 0][Direction.right],
          bottom: circle.positions[gameOn ? 1 : 0][Direction.bottom],
          duration: Config.animationDuration,
          child: CircleAvatar(radius: circle.radius, backgroundColor: Palette.primary),
          // child: AnimatedContainer(
          //   width: gameOn ? circle.altRadius : circle.radius,
          //   height: gameOn ? circle.altRadius : circle.radius,
          //   duration: Config.animationDuration,
          //   decoration: BoxDecoration(color: Palette.primary, shape: BoxShape.circle),
          // ),
        );
      },
    );
  }
}
