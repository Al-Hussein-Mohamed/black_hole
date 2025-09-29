enum Player { none, first, second }

class HoleModel {
  static bool initialized = false;

  HoleModel({
    required this.id,
    required this.row,
    required this.col,
    required this.player,
    required this.value,
  }) {
    init();
  }

  final int id;
  final int row;
  final int col;
  final Player player;
  final int value;

  HoleModel check(Player player, int value) {
    return HoleModel(id: id, row: row, col: col, player: player, value: value);
  }

  static const int LEVELS = 6;
  static final int N = LEVELS * (LEVELS + 1) ~/ 2;
  static List<List<int>> adj = List.generate(N + 1, (i) => []);
  static List<List<int>> position = List.generate(N + 1, (i) => List.generate(2, (j) => 0));
  static List<List<HoleModel>> holes = List.generate(LEVELS, (i) => []);

  static getIdx(int row, int col) {
    return row * (row + 1) ~/ 2 + col + 1;
  }

  static void reset() {
    initialized = false;
    holes = List.generate(LEVELS, (i) => []);
    init();
  }

  static void init() {
    if (initialized) return;
    initialized = true;
    for (int i = 0; i < LEVELS; i++) {
      for (int j = 0; j <= i; j++) {
        int id = getIdx(i, j);
        holes[i].add(HoleModel(id: id, row: i, col: j, player: Player.none, value: 0));
        position[id][0] = i;
        position[id][1] = j;
        // up
        if (0 < i) {
          // up-left
          if (0 < j) {
            int upLeftId = getIdx(i - 1, j - 1);
            adj[id].add(upLeftId);
          }
          // up-right
          if (j < i) {
            int upRightId = getIdx(i - 1, j);
            adj[id].add(upRightId);
          }
        }

        // right
        if (j < i) {
          int rightId = getIdx(i, j + 1);
          adj[id].add(rightId);
        }

        // down
        if (i < LEVELS - 1) {
          // down-right
          if (j < i + 1) {
            int downRightId = getIdx(i + 1, j + 1);
            adj[id].add(downRightId);
          }
          // down-left
          if (0 <= j) {
            int downLeftId = getIdx(i + 1, j);
            adj[id].add(downLeftId);
          }
        }

        // left
        if (0 < j) {
          int leftId = getIdx(i, j - 1);
          adj[id].add(leftId);
        }
      }
    }
  }
}
