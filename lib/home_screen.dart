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
                onTap: () => gameOn ? null : gameStatusCubit.set(true),
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
              SizedBox(height: 12),
              InkWell(
                onTap: () => gameOn ? null : buildShowModalBottomSheet(context),
                child: Container(
                  height: 55,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Palette.secondary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      "How to Play",
                      style: TextStyle(
                        color: Palette.secondary,
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

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Palette.base,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Palette.text,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  "How to Play",
                  style: TextStyle(color: Palette.text, fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text(
                  "• Two players take turns placing numbers into holes.\n"
                  "• One hole will remain unvisited — the Black Hole.\n"
                  "• When no moves remain, the game ends.\n"
                  "• Scoring: consider the holes adjacent to the Black Hole.\n"
                  "  - Sum Player 1’s numbers on those adjacent holes.\n"
                  "  - Sum Player 2’s numbers on those adjacent holes.\n"
                  "  - The player with the smaller sum wins.",
                  style: TextStyle(
                    color: Palette.text.withOpacity(0.9),
                    fontSize: 17,
                    // height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Tip: Plan moves to keep your numbers away from the Black Hole’s neighbors.",
                  style: TextStyle(
                    color: Palette.text.withOpacity(0.9),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      "Got it",
                      style: TextStyle(
                        color: Palette.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
