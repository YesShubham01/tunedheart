import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // return InkWell(
    //   onTap: onPressed,
    //   child: AnimatedContainer(
    //     duration: const Duration(seconds: 2),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(20.0),
    //     ),
    //     color: color,
    //     height: 150,
    //     width: 150,
    //     child: Text(
    //       text,
    //       style: const TextStyle(fontSize: 30, color: Colors.white),
    //     ),
    //   ),
    // );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        minimumSize: const Size(130.0, 60.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Border radius of 10
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 30),
      ),
    );
  }
}
