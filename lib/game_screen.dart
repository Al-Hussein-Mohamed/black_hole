import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/game_cubit.dart';
import 'controllers/game_status_cubit.dart';
import 'core/configuration/config.dart';
import 'core/const/palette.dart';
import 'models/hole_model.dart';

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
                  _AnimatedWidget(
                    animation: CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                    ),
                    child: const _BackButton(),
                  ),
                  const SizedBox(height: 80),
                  _Score(controller: _controller),
                  Expanded(child: _GameBoard(controller: _controller)),
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
        print(state.status);
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
                  style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
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
                    backgroundColor: Palette.secondary,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    "Play Again",
                    style: TextStyle(
                      color: Palette.base,
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

class _AnimatedWidget extends StatelessWidget {
  const _AnimatedWidget({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(animation);

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(animation);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: slideAnimation,
        child: ScaleTransition(scale: scaleAnimation, child: child),
      ),
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

class _Score extends StatelessWidget {
  const _Score({required AnimationController controller}) : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          if (state.status != Status.playing) return _ScoreBoard();
          return _AnimatedWidget(
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
              style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
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
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          width: 60,
          height: 60,
          margin: EdgeInsets.all(7),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              score.toString(),
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _GameBoard extends StatelessWidget {
  const _GameBoard({required this.controller});

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
      children: holes.map((hole) => _AnimatedHole(hole: hole, controller: controller)).toList(),
    );
  }
}

class _AnimatedHole extends StatelessWidget {
  const _AnimatedHole({required this.hole, required this.controller});

  final HoleModel hole;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final totalHoles = HoleModel.N;
    final holeIndex = hole.id - 1;

    final start = 0.4 + (0.6 * (holeIndex / totalHoles));
    final end = start + (0.6 / totalHoles) * 5;
    final interval = Interval(start.clamp(0.4, 1.0), end.clamp(0.4, 1.0), curve: Curves.easeOut);

    return _AnimatedWidget(
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

        if (state.status == Status.finished && state.adj.contains(hole.id) == false) {
          color = color.withAlpha(50);
        }

        if (hole.id == state.blackHole) {
          color = Colors.black;
        }

        return GestureDetector(
          onTap: () => currentHole.player == Player.none ? gameCubit.check(hole.id) : null,
          child: AnimatedContainer(
            duration: Config.shortAnimationDuration,
            width: 50,
            height: 50,
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
