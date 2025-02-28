import 'package:flutter_bloc/flutter_bloc.dart';
import 'number_event.dart';
import 'number_state.dart';
import 'dart:math';
import 'dart:async';

class NumberBloc extends Bloc<NumberEvent, NumberState> {
  NumberBloc() : super(NumberState(numbers: [], currentNumber: null, isLoading: false)) {
    on<GenerateNumberEvent>(_onGenerateNumber);
    on<ResetNumbersEvent>(_onResetNumbers);
  }

  Future<void> _onGenerateNumber(
      GenerateNumberEvent event, Emitter<NumberState> emit) async {
    if (state.numbers.length >= 3) return;

    emit(state.copyWith(isLoading: true)); 
    await Future.delayed(Duration(seconds: 1)); 

    int randomNumber = Random().nextInt(50) + 1;

    List<int> updatedNumbers = List.from(state.numbers)..add(randomNumber);

    emit(state.copyWith(
      numbers: updatedNumbers,
      currentNumber: randomNumber,
      isLoading: false,
    ));
  }

  void _onResetNumbers(ResetNumbersEvent event, Emitter<NumberState> emit) {
    emit(NumberState(numbers: [], currentNumber: null, isLoading: false));
  }
}
