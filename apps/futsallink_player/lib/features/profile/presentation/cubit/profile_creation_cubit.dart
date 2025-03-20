import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_core/domain/usecases/player/create_player_profile.dart';
import 'package:futsallink_core/domain/usecases/player/update_player_profile.dart';
import 'package:futsallink_core/domain/usecases/player/upload_profile_image.dart';
import 'package:futsallink_core/domain/usecases/player/get_profile_completion_status.dart';
import 'package:futsallink_core/domain/usecases/player/get_last_completed_step.dart';
import 'package:futsallink_core/domain/usecases/player/save_partial_profile.dart';
import 'package:futsallink_player/features/profile/data/models/player_model.dart';

part 'profile_creation_state.dart';

class ProfileCreationCubit extends Cubit<ProfileCreationState> {
  final CreatePlayerProfile createPlayerProfile;
  final UpdatePlayerProfile updatePlayerProfile;
  final UploadProfileImage uploadProfileImage;
  final GetCurrentUserUseCase getCurrentUser;
  final GetProfileCompletionStatus getProfileCompletionStatus;
  final GetLastCompletedStep getLastCompletedStep;
  final SavePartialProfile savePartialProfile;
  final GetPlayer getPlayer;

  ProfileCreationCubit({
    required this.createPlayerProfile,
    required this.updatePlayerProfile,
    required this.uploadProfileImage,
    required this.getCurrentUser,
    required this.getProfileCompletionStatus,
    required this.getLastCompletedStep,
    required this.savePartialProfile,
    required this.getPlayer,
  }) : super(ProfileCreationInitial());

  Future<void> initProfileCreation() async {
    emit(ProfileCreationLoading());
    
    final userResult = await getCurrentUser();
    
    await userResult.fold(
      (failure) async {
        emit(ProfileCreationError(failure.toString()));
      },
      (user) async {
        if (user == null) {
          emit(ProfileCreationError('Usuário não encontrado'));
          return;
        }
        
        // Verificar se o perfil existe e seu status
        final statusResult = await getProfileCompletionStatus(
          GetProfileCompletionStatusParams(uid: user.uid),
        );
        
        await statusResult.fold(
          (failure) async {
            // Se falhar ao buscar o status, cria um novo perfil
            final now = DateTime.now();
            final player = PlayerModel.empty(user.uid);
            emit(ProfileCreationActive(
              currentStep: 0,
              player: player,
              totalSteps: 10,
            ));
          },
          (status) async {
            if (status == ProfileCompletionStatus.complete) {
              // Perfil já está completo, redirecionar para a home
              emit(ProfileCreationSuccess(
                // Precisamos carregar o perfil aqui
                await getPlayer(GetPlayerParams(uid: user.uid))
                    .then((result) => result.fold(
                          (failure) => PlayerModel.empty(user.uid),
                          (player) => player,
                        )),
              ));
            } else if (status == ProfileCompletionStatus.partial) {
              // Perfil parcialmente completo, retomar de onde parou
              final stepResult = await getLastCompletedStep(
                GetLastCompletedStepParams(uid: user.uid),
              );
              
              final playerResult = await getPlayer(
                GetPlayerParams(uid: user.uid),
              );
              
              final int lastStep = await stepResult.fold(
                (failure) => 0,
                (step) => step,
              );
              
              final Player player = await playerResult.fold(
                (failure) => PlayerModel.empty(user.uid),
                (player) => player,
              );
              
              // Retorna para a tela seguinte à última concluída
              emit(ProfileCreationActive(
                currentStep: lastStep + 1 >= 10 ? 9 : lastStep + 1,
                player: player,
                totalSteps: 10,
                isCurrentStepValid: true,
              ));
            } else {
              // Perfil não existe, criar novo
              final now = DateTime.now();
              final player = PlayerModel.empty(user.uid);
              emit(ProfileCreationActive(
                currentStep: 0,
                player: player,
                totalSteps: 10,
              ));
            }
          },
        );
      },
    );
  }

  // Método para salvar o progresso ao avançar para o próximo passo
  Future<void> _saveProgress(int completedStep) async {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        lastCompletedStep: completedStep,
        completionStatus: ProfileCompletionStatus.partial,
        updatedAt: DateTime.now(),
      );
      
      await savePartialProfile(
        SavePartialProfileParams(
          player: updatedPlayer,
          lastCompletedStep: completedStep,
        ),
      );
    }
  }

  void updateName(String firstName, String lastName, String? nickname) {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        firstName: firstName,
        lastName: lastName,
        nickname: nickname,
      );
      
      emit(currentState.copyWith(
        player: updatedPlayer,
        isCurrentStepValid: firstName.isNotEmpty && lastName.isNotEmpty,
      ));
    }
  }

  void updateBirthday(DateTime birthday) {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        birthday: birthday,
      );
      
      emit(currentState.copyWith(
        player: updatedPlayer,
        isCurrentStepValid: true,
      ));
    }
  }

  void updatePosition(String position) {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        position: position,
      );
      
      emit(currentState.copyWith(
        player: updatedPlayer,
        isCurrentStepValid: position.isNotEmpty,
      ));
    }
  }

  void updateDominantFoot(String dominantFoot) {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        dominantFoot: dominantFoot,
      );
      
      emit(currentState.copyWith(
        player: updatedPlayer,
        isCurrentStepValid: dominantFoot.isNotEmpty,
      ));
    }
  }

  void updateHeight(int height) {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        height: height,
      );
      
      emit(currentState.copyWith(
        player: updatedPlayer,
        isCurrentStepValid: height > 0,
      ));
    }
  }

  void updateWeight(double weight) {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        weight: weight,
      );
      
      emit(currentState.copyWith(
        player: updatedPlayer,
        isCurrentStepValid: weight > 0,
      ));
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      emit(currentState.copyWith(isUploading: true));
      
      final result = await uploadProfileImage(
        UploadProfileImageParams(
          uid: currentState.player.uid,
          imageFile: imageFile,
        ),
      );
      
      result.fold(
        (failure) {
          emit(currentState.copyWith(
            isUploading: false,
            errorMessage: failure.toString(),
          ));
        },
        (imageUrl) {
          final updatedPlayer = (currentState.player as PlayerModel).copyWith(
            profileImage: imageUrl,
          );
          
          emit(currentState.copyWith(
            player: updatedPlayer,
            isUploading: false,
            isCurrentStepValid: true,
          ));
        },
      );
    }
  }

  void updateBio(String bio) {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        bio: bio,
      );
      
      emit(currentState.copyWith(
        player: updatedPlayer,
        isCurrentStepValid: true,
      ));
    }
  }

  void updateCurrentTeam(String team) {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        currentTeam: team,
      );
      
      emit(currentState.copyWith(
        player: updatedPlayer,
        isCurrentStepValid: team.isNotEmpty,
      ));
    }
  }

  Future<void> goToNextStep() async {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      
      if (currentState.currentStep < currentState.totalSteps - 1) {
        // Salva o progresso atual
        await _saveProgress(currentState.currentStep);
        
        emit(currentState.copyWith(
          currentStep: currentState.currentStep + 1,
          isCurrentStepValid: false,
        ));
      }
    }
  }

  void goToPreviousStep() {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      if (currentState.currentStep > 0) {
        emit(currentState.copyWith(
          currentStep: currentState.currentStep - 1,
        ));
      }
    }
  }

  Future<void> completeProfile() async {
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      emit(currentState.copyWith(isSubmitting: true));
      
      final updatedPlayer = (currentState.player as PlayerModel).copyWith(
        profileCompleted: true,
        completionStatus: ProfileCompletionStatus.complete,
        lastCompletedStep: currentState.totalSteps - 1,
        updatedAt: DateTime.now(),
      );
      
      final result = await createPlayerProfile(
        CreatePlayerProfileParams(player: updatedPlayer),
      );
      
      result.fold(
        (failure) => emit(currentState.copyWith(
          isSubmitting: false,
          errorMessage: failure.toString(),
        )),
        (createdPlayer) => emit(ProfileCreationSuccess(createdPlayer)),
      );
    }
  }
} 