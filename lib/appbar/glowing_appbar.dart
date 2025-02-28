import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'glow_cubit.dart';

class GlowingAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlowCubit, double>(
      builder: (context, glowShift) {
        return AppBar(
          title: ShaderMask(
            shaderCallback: (bounds) {
              return RadialGradient(
                center: Alignment(0.5 + 0.3 * glowShift, 0.5),
                radius: 1.5,
                colors: [
                  Colors.cyanAccent,
                  Colors.blueAccent.withOpacity(0.8),
                  Colors.cyanAccent.withOpacity(0.6),
                ],
                stops: [0.2, 0.5, 1.0],
              ).createShader(bounds);
            },
            child: Text(
              "Number Randomizer",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 10,
          shadowColor: Colors.blueAccent.withOpacity(0.5),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
