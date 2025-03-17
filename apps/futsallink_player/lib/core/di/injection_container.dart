// Em apps/futsallink_player/lib/core/di/injection_container.dart

import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_firebase/futsallink_firebase.dart';
import 'package:futsallink_player/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  //===== Firebase Services =====
  sl.registerLazySingleton<FirestoreService>(
    () => FirestoreService(),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  //===== Repositories =====
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthService>(), sl<FirestoreService>()),
  );

  //===== Use Cases =====
  // Auth Use Cases
  sl.registerLazySingleton(() => SignInWithEmailUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpWithEmailUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => InitiatePhoneVerificationUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyPhoneCodeUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdatePasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));

  //===== BLoCs =====
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInWithEmailUseCase: sl<SignInWithEmailUseCase>(),
      signUpWithEmailUseCase: sl<SignUpWithEmailUseCase>(),
      initiatePhoneVerificationUseCase: sl<InitiatePhoneVerificationUseCase>(),
      verifyPhoneCodeUseCase: sl<VerifyPhoneCodeUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
      updatePasswordUseCase: sl<UpdatePasswordUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
    ),
  );

  // Adicione outras dependências aqui conforme necessário
}