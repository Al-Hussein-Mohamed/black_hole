import 'package:flutter_bloc/flutter_bloc.dart';

class GameStatusCubit extends Cubit<bool> {
  GameStatusCubit() : super(false);

  static GameStatusCubit of(context) => BlocProvider.of<GameStatusCubit>(context);

  void toggle() => emit(!state);
  void set(bool value) => emit(value);
}
