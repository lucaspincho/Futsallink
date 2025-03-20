// Em apps/futsallink_player/lib/core/di/injection_container.dart

import 'package:firebase_storage/firebase_storage.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_core/domain/usecases/player/create_player_profile.dart';
import 'package:futsallink_core/domain/usecases/player/update_player_profile.dart';
import 'package:futsallink_core/domain/usecases/player/upload_profile_image.dart';
import 'package:futsallink_firebase/futsallink_firebase.dart';
import 'package:futsallink_player/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_player/features/profile/data/datasources/player_remote_data_source.dart';
import 'package:futsallink_player/features/profile/data/repositories/player_repository_impl.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:futsallink_core/domain/usecases/player/get_profile_completion_status.dart';
import 'package:futsallink_core/domain/usecases/player/get_last_completed_step.dart';
import 'package:futsallink_core/domain/usecases/player/save_partial_profile.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  //===== Firebase Services =====
  sl.registerLazySingleton<FirestoreService>(
    () => FirestoreService(),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  sl.registerLazySingleton<FirebaseStorage>(
    () => FirebaseStorage.instance,
  );

  //===== Remote Data Sources =====
  sl.registerLazySingleton<PlayerRemoteDataSource>(
    () => PlayerRemoteDataSourceImpl(
      firestoreService: sl<FirestoreService>(),
      firebaseStorage: sl<FirebaseStorage>(),
    ),
  );

  //===== Repositories =====
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthService>(), sl<FirestoreService>()),
  );

  sl.registerLazySingleton<PlayerRepository>(
    () => PlayerRepositoryImpl(remoteDataSource: sl<PlayerRemoteDataSource>()),
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
  sl.registerLazySingleton(() => InitiateEmailVerificationUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyEmailCodeUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => CompleteSignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => CheckEmailRegistrationUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => CheckPhoneRegistrationUseCase(sl<AuthRepository>()));
  
  // Novos Use Cases para redefinição de senha
  sl.registerLazySingleton(() => ResetPasswordViaEmailUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ResetPasswordViaPhoneUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyPasswordResetCodeUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ConfirmPasswordResetUseCase(sl<AuthRepository>()));

  // Player Profile Use Cases
  sl.registerLazySingleton(() => CreatePlayerProfile(sl<PlayerRepository>()));
  sl.registerLazySingleton(() => UpdatePlayerProfile(sl<PlayerRepository>()));
  sl.registerLazySingleton(() => UploadProfileImage(sl<PlayerRepository>()));
  sl.registerLazySingleton(() => GetPlayer(sl<PlayerRepository>()));
  sl.registerLazySingleton(() => GetProfileCompletionStatus(sl<PlayerRepository>()));
  sl.registerLazySingleton(() => GetLastCompletedStep(sl<PlayerRepository>()));
  sl.registerLazySingleton(() => SavePartialProfile(sl<PlayerRepository>()));

  //===== BLoCs/Cubits =====
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
      initiateEmailVerificationUseCase: sl<InitiateEmailVerificationUseCase>(),
      verifyEmailCodeUseCase: sl<VerifyEmailCodeUseCase>(),
      completeSignUpUseCase: sl<CompleteSignUpUseCase>(),
      checkEmailRegistrationUseCase: sl<CheckEmailRegistrationUseCase>(),
      checkPhoneRegistrationUseCase: sl<CheckPhoneRegistrationUseCase>(),
      resetPasswordViaEmailUseCase: sl<ResetPasswordViaEmailUseCase>(),
      resetPasswordViaPhoneUseCase: sl<ResetPasswordViaPhoneUseCase>(),
      verifyPasswordResetCodeUseCase: sl<VerifyPasswordResetCodeUseCase>(),
      confirmPasswordResetUseCase: sl<ConfirmPasswordResetUseCase>(),
      getProfileCompletionStatus: sl<GetProfileCompletionStatus>(),
    ),
  );

  sl.registerFactory<ProfileCreationCubit>(
    () => ProfileCreationCubit(
      createPlayerProfile: sl<CreatePlayerProfile>(),
      updatePlayerProfile: sl<UpdatePlayerProfile>(),
      uploadProfileImage: sl<UploadProfileImage>(),
      getCurrentUser: sl<GetCurrentUserUseCase>(),
      getProfileCompletionStatus: sl<GetProfileCompletionStatus>(),
      getLastCompletedStep: sl<GetLastCompletedStep>(),
      savePartialProfile: sl<SavePartialProfile>(),
      getPlayer: sl<GetPlayer>(),
    ),
  );

  // Adicione outras dependências aqui conforme necessário
}
