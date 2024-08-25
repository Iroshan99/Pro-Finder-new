import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test8/firebase_options.dart';
import 'package:test8/loginuser.dart';
import 'package:test8/signupprovider.dart';
import 'package:test8/signupuser.dart';
import 'chat_screen.dart';
import 'splash_screen.dart';
import 'Firstpage.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenWrapper(),
      routes: {
        '/chat': (context) => ChatScreen(),
        '/home': (context) => HomePage(), // Use HomePage route
      },
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}



