import 'package:black_hole/widgets/custom_animated_widget.dart';
import 'package:black_hole/widgets/game_baord.dart';
import 'package:black_hole/widgets/score_and_instructions_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/game_cubit.dart';
import 'controllers/game_status_cubit.dart';
import 'core/const/palette.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameStatusCubit, bool>(
      listener: (context, gameOn) {
        if (gameOn) {
          _controller.forward(from: 0);
        } else {
          _controller.reset();
        }
      },
      builder: (context, gameOn) {
        return IgnorePointer(
          ignoring: !gameOn,
          child: Stack(
            children: [
              Column(
                children: [
                  CustomAnimatedWidget(
                    animation: CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                    ),
                    child: const _BackButton(),
                  ),
                  const SizedBox(height: 80),
                  ScoreAndInstructionsWidget(controller: _controller),
                  Flexible(child: GameBoard(controller: _controller)),
                ],
              ),
              const _ShowResults(),
            ],
          ),
        );
      },
    );
  }
}

class _ShowResults extends StatelessWidget {
  const _ShowResults();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        if (state.status != Status.showResult) return SizedBox.shrink();
        return Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.score1 < state.score2
                      ? "Player 1 Wins!"
                      : state.score2 < state.score1
                      ? "Player 2 Wins!"
                      : "It's a Draw!",
                  style: TextStyle(color: Palette.text, fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final gameStatusCubit = GameStatusCubit.of(context);
                    final gameCubit = GameCubit.of(context);
                    gameStatusCubit.set(false);
                    gameCubit.reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.text,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    "Play Again",
                    style: TextStyle(
                      color: Palette.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    final gameStatusCubit = GameStatusCubit.of(context);
    final gameCubit = GameCubit.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: () {
            gameStatusCubit.set(false);
            gameCubit.reset();
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Palette.base),
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(CircleBorder()),
            backgroundColor: WidgetStatePropertyAll(Palette.secondary),
          ),
        ),
      ),
    );
  }
}
