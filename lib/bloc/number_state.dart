class NumberState {
  final List<int> numbers;
  final int? currentNumber;
  final bool isLoading;

  NumberState({required this.numbers, this.currentNumber, required this.isLoading});

  NumberState copyWith({List<int>? numbers, int? currentNumber, bool? isLoading}) {
    return NumberState(
      numbers: numbers ?? this.numbers,
      currentNumber: currentNumber ?? this.currentNumber,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
