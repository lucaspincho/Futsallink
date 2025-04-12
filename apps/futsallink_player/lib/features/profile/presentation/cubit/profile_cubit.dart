import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/futsallink_core.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetPlayer getPlayer;
  final GetCurrentUserUseCase getCurrentUser;

  ProfileCubit({
    required this.getPlayer,
    required this.getCurrentUser,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());

    try {
      final userResult = await getCurrentUser();
      
      await userResult.fold(
        (failure) {
          emit(ProfileError(failure.toString()));
        },
        (user) async {
          if (user == null) {
            emit(ProfileError('Usuário não encontrado'));
            return;
          }
          
          final playerResult = await getPlayer(GetPlayerParams(uid: user.uid));
          
          playerResult.fold(
            (failure) {
              emit(ProfileError(failure.toString()));
            },
            (player) {
              emit(ProfileLoaded(player));
            },
          );
        },
      );
    } catch (e) {
      emit(ProfileError('Erro inesperado: $e'));
    }
  }
} 