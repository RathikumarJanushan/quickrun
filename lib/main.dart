import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickrun/startup_view.dart';
import 'package:quickrun/view/admin/menu/adminhome_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
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
      title: 'Food Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      themeMode:
          ThemeMode.system, // Adjust to ThemeMode.dark to force dark theme
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => const StartupView(),
        // '/home': (context) => const HomeScreen(),
//        // '/login': (context) => const WelcomeView(),
        '/adminhome': (context) => const AdminhomeScreen(),
        // Add more routes if needed
      },
    );
  }
}
