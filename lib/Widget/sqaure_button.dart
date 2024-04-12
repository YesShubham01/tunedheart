import 'package:flutter/material.dart';

class SqaureButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Widget icon;
  const SqaureButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20.0),
            ),
            height: 110,
            width: 110,
            child: icon,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ],
    );
  }
}
