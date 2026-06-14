import 'package:firebase_chat_app/presentation/chats/bloc/chats_cubit.dart';
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
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => sl<ChatsCubit>()),
      ],
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
