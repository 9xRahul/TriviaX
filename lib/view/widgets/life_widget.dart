import 'package:flutter/material.dart';

class LifeWidget extends StatelessWidget {
  final int lives;
  const LifeWidget({super.key, required this.lives});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(
            index < lives ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
