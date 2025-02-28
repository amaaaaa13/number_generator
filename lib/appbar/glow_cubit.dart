import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class GlowCubit extends Cubit<double> {
  GlowCubit() : super(0.0) {
    animateGlow();
  }

  void animateGlow() async {
    while (true) {
      for (double t = 0; t <= 1; t += 0.01) {
        emit(sin(t * pi * 2)); // Moves glow left & right
        await Future.delayed(Duration(milliseconds: 50));
      }
    }
  }
}
