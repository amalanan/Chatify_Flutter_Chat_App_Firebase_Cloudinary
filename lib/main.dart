import 'package:firebase_chat_app/pages/home_page.dart';
import 'package:firebase_chat_app/pages/login_page.dart';
import 'package:firebase_chat_app/pages/register_page.dart';
import 'package:firebase_chat_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import './pages/splash_page.dart';

void main() async {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(MainApp());
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider<AuthenticationProvider>(
    //       create: (BuildContext _context) {
    //         return AuthenticationProvider();
    //       },
    //     )
    //   ],
    //   child:
    return MaterialApp(
      title: 'Chatify',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(36, 35, 49, 1.0),
          brightness: Brightness.dark,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
        ),
      ),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext _context) => LoginPage(),
        '/register': (BuildContext _context) => RegisterPage(),
        '/home': (BuildContext _context) => HomePage(),
      },
      //   ),
    );
  }
}
