import 'package:black_hole/core/configuration/config.dart';
import 'package:black_hole/models/hole_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Status { playing, finished, showResult }

class GameState {
  const GameState({
    required this.status,
    required this.player,
    required this.currentValue,
    required this.holes,
    this.blackHole = -1,
    this.score1 = 0,
    this.score2 = 0,
    this.adj = const {},
  });

  final Status status;
  final Player player;
  final int currentValue;
  final List<List<HoleModel>> holes;
  final int blackHole;
  final int score1;
  final int score2;
  final Set<int> adj;
}

class GameCubit extends Cubit<GameState> {
  GameCubit()
    : super(
        GameState(
          status: Status.playing,
          player: Player.first,
          currentValue: 1,
          holes: HoleModel.holes,
        ),
      ) {
    _fillRemaining();
  }

  static GameCubit of(context) => BlocProvider.of<GameCubit>(context);
  Set<int> remaining = {};

  void _fillRemaining() {
    for (int i = 1; i <= HoleModel.N; i++) {
      remaining.add(i);
    }
  }

  void reset() {
    _fillRemaining();
    emit(
      GameState(
        status: Status.playing,
        player: Player.first,
        currentValue: 1,
        holes: HoleModel.holes,
      ),
    );
  }

  void check(int id) {
    if (remaining.length == 1) return;
    if (remaining.contains(id) == false) return;
    remaining.remove(id);

    int row = HoleModel.position[id][0];
    int col = HoleModel.position[id][1];
    final HoleModel hole = state.holes[row][col];
    if (hole.player != Player.none) return;

    final newHole = hole.check(state.player, state.currentValue);
    List<List<HoleModel>> newHoles =
        state.holes
            .map((row) => row.map((hole) => hole.id == id ? newHole : hole).toList())
            .toList();

    int blackHole = -1;
    if (remaining.length == 1) blackHole = remaining.first;

    emit(
      GameState(
        status: blackHole != -1 ? Status.finished : Status.playing,
        player: state.player == Player.first ? Player.second : Player.first,
        currentValue: state.currentValue + (state.player == Player.second ? 1 : 0),
        holes: newHoles,
        blackHole: blackHole,
      ),
    );

    if (blackHole != -1) {
      _endGame(blackHole);
    }
  }

  void _endGame(int blackHole) async {
    for (var holeId in HoleModel.adj[blackHole]) {
      await Future.delayed(Config.calcResultDuration);
      calcHole(holeId);
    }
    await Future.delayed(const Duration(milliseconds: 700));
    emit(
      GameState(
        status: Status.showResult,
        player: state.player,
        currentValue: state.currentValue,
        holes: state.holes,
        blackHole: blackHole,
        score1: state.score1,
        score2: state.score2,
        adj: state.adj,
      ),
    );
  }

  void calcHole(int id) {
    int row = HoleModel.position[id][0];
    int col = HoleModel.position[id][1];
    final hole = state.holes[row][col];

    int newScore1 = state.score1;
    int newScore2 = state.score2;
    if (hole.player == Player.first) newScore1 += hole.value;
    if (hole.player == Player.second) newScore2 += hole.value;
    emit(
      GameState(
        status: state.status,
        player: state.player,
        currentValue: state.currentValue,
        holes: state.holes,
        blackHole: state.blackHole,
        score1: newScore1,
        score2: newScore2,
        adj: {...state.adj, id},
      ),
    );
  }
}
