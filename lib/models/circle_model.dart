enum Direction { top, left, right, bottom }

class CircleModel {
  const CircleModel({required this.id, required this.radius, required this.positions});
  final int id;
  final double radius;
  final List<Map<Direction, double>> positions;

  static List<CircleModel> backgroundCircles = [
    CircleModel(
      id: 1,
      radius: 120,
      positions: [
        {Direction.top: -60, Direction.left: -60},
        {Direction.top: -200, Direction.left: -200},
      ],
    ),
    CircleModel(
      id: 2,
      radius: 80,
      positions: [
        {Direction.top: 120, Direction.right: -60},
        {Direction.top: 100, Direction.right: -200},
      ],
    ),
    CircleModel(
      id: 3,
      radius: 235,
      positions: [
        {Direction.bottom: -150, Direction.right: -90},
        {Direction.bottom: -650, Direction.right: -120},
      ],
    ),
  ];
}
