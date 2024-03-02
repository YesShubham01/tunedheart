import 'package:flutter/material.dart';

class TeamSection extends StatelessWidget {
  final String title;
  final Color headingColor;
  final Color lineColor;

  final Widget content;

  const TeamSection({
    super.key,
    required this.title,
    required this.headingColor,
    required this.content,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: lineColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 30,
              color: headingColor,
            ),
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}
