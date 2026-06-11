import 'package:firebase_chat_app/providers/authentication_provider.dart';
import 'package:firebase_chat_app/services/cloudinary_service.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:firebase_chat_app/services/media_service.dart';
import 'package:firebase_chat_app/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

import 'data/repository/auth/auth_repository_impl.dart';
import 'data/sources/auth/auth_firebase_service.dart';
import 'domain/repository/auth/auth.dart';
import 'domain/usecases/auth/get_user.dart';
import 'domain/usecases/auth/signin.dart';
import 'domain/usecases/auth/signup.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<NavigationService>(NavigationService());
  sl.registerSingleton<MediaService>(MediaService());
  sl.registerSingleton<CloudinaryService>(CloudinaryService());
  sl.registerSingleton<DatabaseService>(DatabaseService());
  sl.registerSingleton<AuthenticationProvider>(AuthenticationProvider());
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
}
