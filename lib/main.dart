import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tunedheart/Login/login_page.dart';
import 'package:tunedheart/Pages/Profile/profile_page.dart';
import 'package:tunedheart/Rooms/homePage.dart';
import 'package:tunedheart/Providers/music_provider.dart';
import 'package:tunedheart/SplashPage/splashpage.dart';
import 'package:tunedheart/firebase_options.dart';
import 'package:provider/provider.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => MusicProvider())),
      ],
      child: MaterialApp(
        title: 'TunedHeartz',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(roomCode: '7000',),
      ),
    );
  }
}
