import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:number_generator/appbar/glow_cubit.dart';
import 'package:number_generator/appbar/glowing_appbar.dart';
import 'bloc/number_bloc.dart';
import 'bloc/number_event.dart';
import 'bloc/number_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NumberBloc()),
        BlocProvider(create: (context) => GlowCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RandomNumberScreen(),
      ),
    );
  }
}

class RandomNumberScreen extends StatefulWidget {
  @override
  _RandomNumberScreenState createState() => _RandomNumberScreenState();
}

class _RandomNumberScreenState extends State<RandomNumberScreen> {
  final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 2));

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: GlowingAppBar(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti Effect
          BlocListener<NumberBloc, NumberState>(
            listener: (context, state) {
              if (state.numbers.length == 3) {
                _confettiController.stop(); 
                Future.delayed(Duration(milliseconds: 100), () {
                  _confettiController.play();
                });
              }
            },
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.08,
              numberOfParticles: 100,
              gravity: 0.2,
              colors: [
                Colors.blueAccent,
                Colors.cyan,
                Colors.purpleAccent,
                Colors.amberAccent,
                Colors.pinkAccent,
                Colors.white,
              ],
              createParticlePath: (size) {
                var path = Path();
                path.moveTo(size.width / 2, 0);
                path.lineTo(size.width, size.height / 2);
                path.lineTo(size.width / 2, size.height);
                path.lineTo(0, size.height / 2);
                path.close();
                return path; // Diamond shape
              },
            ),
          ),

          // Main UI
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<NumberBloc, NumberState>(
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 600),
                      transitionBuilder: (widget, animation) {
                        return ScaleTransition(scale: animation, child: widget);
                      },
                      child: state.isLoading
                          ? CircularProgressIndicator(color: Colors.blueAccent)
                          : Text(
                              state.currentNumber != null
                                  ? "${state.currentNumber}"
                                  : "Tap to generate 3 numbers from 1 - 50",
                              key: ValueKey(state.currentNumber),
                              style: TextStyle(
                                fontSize:
                                    state.currentNumber != null ? 130 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent,
                                shadows: [
                                  Shadow(
                                      blurRadius: 20, color: Colors.cyanAccent),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                    );
                  },
                ),
                SizedBox(height: 30),
                BlocBuilder<NumberBloc, NumberState>(
                  builder: (context, state) {
                    bool isFull = state.numbers.length == 3;
                    return GestureDetector(
                      onTap: () {
                        if (isFull) {
                          context.read<NumberBloc>().add(ResetNumbersEvent());
                        } else {
                          context.read<NumberBloc>().add(GenerateNumberEvent());
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        decoration: BoxDecoration(
                          color: isFull ? Colors.redAccent : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isFull
                                  ? Colors.redAccent.withOpacity(0.6)
                                  : Colors.blueAccent.withOpacity(0.6),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          isFull ? "Reset" : "Generate",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40),
                BlocBuilder<NumberBloc, NumberState>(
                  builder: (context, state) {
                    return Container(
                      width: 400,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white24,
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (index) {
                          bool isFilled = state.numbers.length > index;
                          return AnimatedContainer(
                            duration:
                                Duration(milliseconds: 500 + (index * 200)),
                            curve: Curves.easeInOut,
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isFilled
                                  ? Colors.purpleAccent
                                  : Colors.white12,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isFilled
                                  ? [
                                      BoxShadow(
                                        color: Colors.purpleAccent
                                            .withOpacity(0.6),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 400),
                              transitionBuilder: (widget, animation) {
                                return FadeTransition(
                                    opacity: animation, child: widget);
                              },
                              child: Text(
                                isFilled ? "${state.numbers[index]}" : "",
                                key: ValueKey(state.numbers.length > index
                                    ? state.numbers[index]
                                    : -1),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
