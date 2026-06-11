// import 'package:device_preview/device_preview.dart';
// import 'package:firebase_chat_app/pages/home_page.dart';
// import 'package:firebase_chat_app/pages/login_page.dart';
// import 'package:firebase_chat_app/pages/register_page.dart';
// import 'package:firebase_chat_app/providers/authentication_provider.dart';
// import 'package:firebase_chat_app/services/cloudinary_service.dart';
// import 'package:firebase_chat_app/services/database_service.dart';
// import 'package:firebase_chat_app/services/media_service.dart';
// import 'package:firebase_chat_app/services/navigation_service.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import './pages/splash_page.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   runApp(
//     DevicePreview(
//       enabled: false,
//       builder: (context) => MainApp(),
//     ),
//   );
// }
//
// class MainApp extends StatefulWidget {
//   @override
//   State<MainApp> createState() => _MainAppState();
// }
//
// class _MainAppState extends State<MainApp> {
//
//   @override
//   void initState() {
//     super.initState();
//     _initApp();
//   }
//
//   Future<void> _initApp() async {
//     _registerServices();
//
//     await Future.delayed(Duration(seconds: 1));
//
//     GetIt.instance<AuthenticationProvider>().setAppReady();
//
//
//   }
//
//   // Future<void> _initApp() async {
//   //   _registerServices();
//   //
//   //   await Future.delayed(Duration(seconds: 1));
//   //
//   //   setState(() {
//   //     _initialized = true;
//   //   });
//   //
//   // }
//
//   void _registerServices() {
//     GetIt.instance.registerSingleton<NavigationService>(NavigationService());
//     GetIt.instance.registerSingleton<MediaService>(MediaService());
//     GetIt.instance.registerSingleton<CloudinaryService>(CloudinaryService());
//     GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
//     GetIt.instance.registerSingleton<AuthenticationProvider>(
//       AuthenticationProvider(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       builder: DevicePreview.appBuilder,
//       locale: DevicePreview.locale(context),
//       navigatorKey: NavigationService.navigatorKey,
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home:  SplashScreenUI(),
//     );
//   }
// }
//
// // class MainApp extends StatefulWidget {
// //   @override
// //   State<MainApp> createState() => _MainAppState();
// // }
// //
// // class _MainAppState extends State<MainApp> {
// //   @override
// //   Widget build(BuildContext context) {
// //     // return MultiProvider(
// //     //   providers: [
// //     //     ChangeNotifierProvider<AuthenticationProvider>(
// //     //       create: (BuildContext _context) {
// //     //         return AuthenticationProvider();
// //     //       },
// //     //     )
// //     //   ],
// //     //   child:
// //     return MaterialApp(
// //       title: 'Chatify',
// //       theme: ThemeData(
// //         scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
// //         colorScheme: ColorScheme.fromSeed(
// //           seedColor: const Color.fromRGBO(36, 35, 49, 1.0),
// //           brightness: Brightness.dark,
// //         ),
// //         bottomNavigationBarTheme: BottomNavigationBarThemeData(
// //           backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
// //         ),
// //       ),
// //       navigatorKey: NavigationService.navigatorKey,
// //       initialRoute: '/login',
// //       routes: {
// //         '/login': (BuildContext _context) => LoginPage(),
// //         '/register': (BuildContext _context) => RegisterPage(),
// //         '/home': (BuildContext _context) => HomePage(),
// //       },
// //       //   ),
// //     );
// //   }
// // }
import 'package:firebase_chat_app/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:firebase_chat_app/presentation/splash/pages/splash.dart';
import 'package:firebase_chat_app/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'core/configs/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeCubit())],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder:
            (context, mode) => MaterialApp(
              themeMode: mode,
              debugShowCheckedModeBanner: false,
              home: const SplashPage(),
              darkTheme: AppTheme.darkTheme,
              theme: AppTheme.lightTheme,
            ),
      ),
    );
  }
}
