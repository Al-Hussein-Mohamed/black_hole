import 'package:black_hole/controllers/game_cubit.dart';
import 'package:black_hole/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'background.dart';
import 'controllers/game_status_cubit.dart';
import 'core/configuration/config.dart';
import 'core/const/palette.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.base,
      body: Stack(
        children: [
          const Background(),
          const _Components(),
          BlocProvider(create: (context) => GameCubit(), child: const GameScreen()),
        ],
      ),
    );
  }
}

class _Components extends StatelessWidget {
  const _Components();

  @override
  Widget build(BuildContext context) {
    final gameStatusCubit = GameStatusCubit.of(context);
    return BlocBuilder<GameStatusCubit, bool>(
      builder: (context, gameOn) {
        return AnimatedOpacity(
          duration: Config.animationDuration,
          opacity: gameOn ? 0 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 320),
              Center(
                child: Text(
                  "Black Hole",
                  style: TextStyle(
                    color: Palette.secondary,
                    fontSize: 78,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () => gameStatusCubit.set(true),
                child: Container(
                  height: 55,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Palette.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Palette.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
