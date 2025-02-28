// ORIGINAL CODE WITHOUT DESIGN IMPROVEMENTS

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/number_bloc.dart';
import 'bloc/number_event.dart';
import 'bloc/number_state.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BlocProvider(
//         create: (context) => NumberBloc(),
//         child: RandomNumberScreen(),
//       ),
//     );
//   }
// }

class RandomNumberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Number Randomizer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display generated number before storing
            BlocBuilder<NumberBloc, NumberState>(
              builder: (context, state) {
                return state.isLoading
                    ? CircularProgressIndicator() // Show loading indicator
                    : Text(
                        state.currentNumber != null
                            ? "${state.currentNumber}" // Generated number is BIG and BOLD
                            : "Generate 3 random numbers from 1 - 50", // Default message (smaller)
                        style: TextStyle(
                          fontSize: state.currentNumber != null ? 100 : 21,
                          fontWeight: state.currentNumber != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.black87, // Stronger color
                        ),
                        textAlign: TextAlign.center,
                      );
              },
            ),
            SizedBox(height: 40),

            // Generate or Reset button
            BlocBuilder<NumberBloc, NumberState>(
              builder: (context, state) {
                bool isFull = state.numbers.length == 3;
                return ElevatedButton(
                  onPressed: () {
                    if (isFull) {
                      context.read<NumberBloc>().add(ResetNumbersEvent());
                    } else {
                      context.read<NumberBloc>().add(GenerateNumberEvent());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFull ? Colors.red : Colors.black, // Dynamic color
                    minimumSize: Size(220, 70), // Fat button
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                    ),
                  ),
                  child: Text(
                    isFull ? "Reset" : "Generate",
                    style: TextStyle(
                      fontSize: 24, // Bigger text
                      fontWeight: FontWeight.bold, // Bold
                      color: Colors.white, // White text
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40),

            // Stored Numbers Box (One box turns red at a time)
            BlocBuilder<NumberBloc, NumberState>(
              builder: (context, state) {
                return Container(
                  width: 400,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey, // Default box color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: state.numbers.length > index
                                ? Colors.red // Box turns red if number exists
                                : Colors.grey,
                            border: Border(
                              right: index < 2
                                  ? BorderSide(color: Colors.white, width: 2)
                                  : BorderSide.none,
                            ),
                          ),
                          child: Text(
                            (state.numbers.length > index)
                                ? "${state.numbers[index]}"
                                : "", // Show stored number if available
                            style: TextStyle(
                              fontSize: 28, // Bigger stored numbers
                              fontWeight: FontWeight.bold, // Bold
                              color: Colors.white, // White text
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
