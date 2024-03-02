import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tunedheart/Login/bottom_rectangles.dart';
import 'package:tunedheart/Rooms/room_page.dart';
import 'package:tunedheart/Widget/google_sign_in_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late StreamController<int> _stateController;
  late int state;
  bool process = false;
  bool buttonvisible = true;

  @override
  void initState() {
    super.initState();
    _stateController = StreamController<int>();
    state = 0;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        state = 4; // Change state to 1 after 2 seconds
        _stateController.add(state);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Stack(
        children: [
          getIcon(),
          getLoginButton(),
          Column(
            children: [
              const Spacer(),
              Text(
                state.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                // 0 : Start   4: Active    5: About to State     1,2,3: Loading States
                child: BottomRectangles(
                  state: state,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void processAnimation() async {
    process = true;
    int counter = 2;
    while (process) {
      state = (counter % 3) + 1; // Switch between 1, 2, and 3
      counter++;
      _stateController.add(state);
      print(state);
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }

  void stopAnimation() {
    setState(() {
      process = false;
      _exitAnimation();
    });
  }

  void _exitAnimation() async {
    setState(() {
      state = 6;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      state = 7;
      print("yes yes yes");
    });
    buttonvisible = false;

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      state = 8;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      state = 9;
    });

    await Future.delayed(const Duration(seconds: 2));
    //navigator here.
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const RoomPage()));

    print(state);
  }

  getIcon() {
    if (buttonvisible) {
      return Center(
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Lottie.asset(
              'assets/breath_animation.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              repeat: true, // Set repeat to true for infinite looping
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  getLoginButton() {
    if (buttonvisible) {
      return Center(
          child: GoogleSignInButton(
        ontap_start: processAnimation,
        ontap_stop: stopAnimation,
      ));
    } else {
      return const Center(
        child: Text("Welcome",
            style: TextStyle(
                color: Colors.white, fontSize: 48, fontFamily: "delius")),
      );
    }
  }
}
