import 'package:black_hole/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/game_status_cubit.dart';
import 'models/hole_model.dart';

void main() {
  HoleModel.init();
  runApp(const BlackHole());
}

class BlackHole extends StatelessWidget {
  const BlackHole({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Black Hole',
      theme: ThemeData(fontFamily: "lobster"),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(create: (context) => GameStatusCubit(), child: const HomeScreen()),
    );
  }
}
