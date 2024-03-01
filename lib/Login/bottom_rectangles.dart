import 'package:flutter/material.dart';

class BottomRectangles extends StatefulWidget {
  final int state;
  const BottomRectangles({super.key, required this.state});

  @override
  State<BottomRectangles> createState() => _BottomRectanglesState();
}

class _BottomRectanglesState extends State<BottomRectangles> {
  int state = 0;
  // 0 : Start   4: Active    5: About to State     1,2,3: Loading States

  final Duration _duration = const Duration(milliseconds: 400);
  late double screenHeight;
  double width = 30;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.sizeOf(context).height;
    // double width = _getWidthForStates(state);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: _duration,
          width: width,
          height: _getHeightForStates(widget.state, 0),
          decoration: const BoxDecoration(color: Color(0xFFEA4335)),
        ),
        AnimatedContainer(
          duration: _duration,
          width: width,
          height: _getHeightForStates(widget.state, 1),
          decoration: const BoxDecoration(color: Color(0xFFEA4335)),
        ),
        AnimatedContainer(
          duration: _duration,
          width: width,
          height: _getHeightForStates(widget.state, 2),
          decoration: const BoxDecoration(color: Color(0xFFFBBC05)),
        ),
        AnimatedContainer(
          duration: _duration,
          width: width,
          height: _getHeightForStates(widget.state, 3),
          decoration: const BoxDecoration(color: Colors.white),
        ),
        AnimatedContainer(
          duration: _duration,
          width: width,
          height: _getHeightForStates(widget.state, 4),
          decoration: const BoxDecoration(color: Color(0xFF34A853)),
        ),
        AnimatedContainer(
          duration: _duration,
          width: width,
          height: _getHeightForStates(widget.state, 5),
          decoration: const BoxDecoration(color: Color(0xFF4285F4)),
        ),
        AnimatedContainer(
          duration: _duration,
          width: width,
          height: _getHeightForStates(widget.state, 6),
          decoration: const BoxDecoration(color: Color(0xFF4285F4)),
        ),
      ],
    );
  }

  double _getHeightForStates(int state, int index) {
    switch (state) {
      case 0:
        return 40.00;
      case 1:
        List<double> heights = [130, 150, 170, 190, 210, 230, 250];
        return heights[index];
      case 2:
        List<double> heights = [190, 210, 230, 250, 230, 210, 190];
        return heights[index];
      case 3:
        List<double> heights = [250, 230, 210, 190, 170, 150, 130];
        return heights[index];
      case 4:
        List<double> heights = [170, 150, 210, 300, 210, 150, 170];
        return heights[index];
      case 5:
        return 140.00;
      case 6:
        return screenHeight - 20;
      case 7:
        width = 52;
        return screenHeight - 20;
      default:
        return screenHeight - 20;
    }
  }
}
