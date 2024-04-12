import 'package:flutter/material.dart';
import 'package:tunedheart/Login/login_page.dart';
import 'package:tunedheart/Pages/Rooms/room_page.dart';
import 'package:tunedheart/Services/FireAuth%20Service/authentication.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _checkAuthenticationAndNavigate() async {
    if (Authenticate.isLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoomPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to schedule navigation after build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        _checkAuthenticationAndNavigate();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            Text(
              'Welcome to TunedHeartz',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
