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
  }) : super(ProfileCreationInitial()) {
    print("[ProfileCreationCubit] Inicializado");
  }

  @override
  Future<void> close() {
    print("[ProfileCreationCubit] Fechando cubit");
    return super.close();
  }

  Future<void> initProfileCreation([User? providedUser]) async {
    print("[ProfileCreationCubit] Iniciando criação de perfil");
    
    if (isClosed) {
      print("[ProfileCreationCubit] Tentativa de inicializar um cubit fechado");
      return;
    }
    
    try {
      emit(ProfileCreationLoading());
      
      final User? user = providedUser ?? await _getCurrentUserSafely();
      
      if (user == null) {
        if (!isClosed) {
          print("[ProfileCreationCubit] Usuário não encontrado");
          emit(ProfileCreationError('Usuário não encontrado'));
        }
        return;
      }
      
      print("[ProfileCreationCubit] Verificando status do perfil para usuário: ${user.uid}");
      
      // Verificar se o perfil existe e seu status
      final statusResult = await getProfileCompletionStatus(
        GetProfileCompletionStatusParams(uid: user.uid),
      );
      
      if (isClosed) {
        print("[ProfileCreationCubit] Cubit fechado após verificação de status");
        return;
      }
      
      await statusResult.fold(
        (failure) async {
          print("[ProfileCreationCubit] Falha ao buscar status: ${failure.toString()}");
          // Se falhar ao buscar o status, cria um novo perfil
          if (!isClosed) {
            final player = PlayerModel.empty(user.uid);
            emit(ProfileCreationActive(
              currentStep: 0,
              player: player,
              totalSteps: 10,
            ));
          }
        },
        (status) async {
          print("[ProfileCreationCubit] Status do perfil: $status");
          
          if (isClosed) {
            print("[ProfileCreationCubit] Cubit fechado após processamento de status");
            return;
          }
          
          if (status == ProfileCompletionStatus.complete) {
            // Perfil já está completo, redirecionar para a home
            print("[ProfileCreationCubit] Perfil completo, carregando dados");
            final player = await getPlayer(GetPlayerParams(uid: user.uid))
                .then((result) => result.fold(
                      (failure) => PlayerModel.empty(user.uid),
                      (player) => player,
                    ));
            
            if (!isClosed) {
              emit(ProfileCreationSuccess(player));
            }
          } else if (status == ProfileCompletionStatus.partial) {
            // Perfil parcialmente completo, retomar de onde parou
            print("[ProfileCreationCubit] Perfil parcial, retomando de onde parou");
            final stepResult = await getLastCompletedStep(
              GetLastCompletedStepParams(uid: user.uid),
            );
            
            final playerResult = await getPlayer(
              GetPlayerParams(uid: user.uid),
            );
            
            if (isClosed) {
              print("[ProfileCreationCubit] Cubit fechado durante carregamento de dados parciais");
              return;
            }
            
            final int lastStep = await stepResult.fold(
              (failure) => 0,
              (step) => step,
            );
            
            final Player player = await playerResult.fold(
              (failure) => PlayerModel.empty(user.uid),
              (player) => player,
            );
            
            print("[ProfileCreationCubit] Último passo concluído: $lastStep");
            
            // Retorna para a tela seguinte à última concluída
            if (!isClosed) {
              emit(ProfileCreationActive(
                currentStep: lastStep + 1 >= 10 ? 9 : lastStep + 1,
                player: player,
                totalSteps: 10,
                isCurrentStepValid: true,
              ));
            }
          } else {
            // Perfil não existe, criar novo
            print("[ProfileCreationCubit] Perfil não existe, criando novo");
            if (!isClosed) {
              final player = PlayerModel.empty(user.uid);
              emit(ProfileCreationActive(
                currentStep: 0,
                player: player,
                totalSteps: 10,
              ));
            }
          }
        },
      );
    } catch (e) {
      print("[ProfileCreationCubit] Erro ao inicializar perfil: $e");
      if (!isClosed) {
        emit(ProfileCreationError(e.toString()));
      }
    }
  }

  // Método auxiliar para obter o usuário atual com tratamento de erro
  Future<User?> _getCurrentUserSafely() async {
    try {
      final userResult = await getCurrentUser();
      return userResult.fold(
        (failure) => null,
        (user) => user,
      );
    } catch (e) {
      print("[ProfileCreationCubit] Erro ao obter usuário atual: $e");
      return null;
    }
  }

  // Método para salvar o progresso ao avançar para o próximo passo
  Future<void> _saveProgress(int completedStep) async {
    if (isClosed) {
      print("[ProfileCreationCubit] Tentativa de salvar progresso com cubit fechado");
      return;
    }
    
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      
      try {
        print("[ProfileCreationCubit] Salvando progresso: passo $completedStep");
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
        print("[ProfileCreationCubit] Progresso salvo com sucesso");
      } catch (e) {
        print("[ProfileCreationCubit] Erro ao salvar progresso: $e");
      }
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
            isCurrentStepValid: true, // Sempre válido, pois é opcional
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

  void goToNextStep() {
    if (isClosed) {
      print("[ProfileCreationCubit] Tentativa de avançar passo com cubit fechado");
      return;
    }
    
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      
      final newStep = currentState.currentStep + 1;
      if (newStep < currentState.totalSteps) {
        print("[ProfileCreationCubit] Avançando para o passo $newStep");
        _saveProgress(currentState.currentStep);
        
        emit(currentState.copyWith(
          currentStep: newStep,
          isCurrentStepValid: false, // Reset validity for the new step
        ));
      }
    }
  }

  void goToPreviousStep() {
    if (isClosed) {
      print("[ProfileCreationCubit] Tentativa de voltar passo com cubit fechado");
      return;
    }
    
    if (state is ProfileCreationActive) {
      final currentState = state as ProfileCreationActive;
      
      final newStep = currentState.currentStep - 1;
      if (newStep >= 0) {
        print("[ProfileCreationCubit] Voltando para o passo $newStep");
        emit(currentState.copyWith(
          currentStep: newStep,
          isCurrentStepValid: true, // Assume previous steps are valid
        ));
      }
    }
  }

  Future<void> completeProfile() async {
    if (isClosed) {
      print("[ProfileCreationCubit] Tentativa de completar perfil com cubit fechado");
      return;
    }
    
    if (state is ProfileCreationActive) {
      try {
        final currentState = state as ProfileCreationActive;
        print("[ProfileCreationCubit] Iniciando conclusão do perfil");
        
        emit(currentState.copyWith(isSubmitting: true));
        
        final updatedPlayer = (currentState.player as PlayerModel).copyWith(
          completionStatus: ProfileCompletionStatus.complete,
          updatedAt: DateTime.now(),
        );
        
        final result = await createPlayerProfile(
          CreatePlayerProfileParams(player: updatedPlayer),
        );
        
        if (isClosed) return;
        
        result.fold(
          (failure) {
            print("[ProfileCreationCubit] Falha ao criar perfil: ${failure.toString()}");
            emit(currentState.copyWith(
              isSubmitting: false,
              errorMessage: failure.toString(),
            ));
          },
          (success) {
            print("[ProfileCreationCubit] Perfil criado com sucesso");
            emit(ProfileCreationSuccess(updatedPlayer));
          },
        );
      } catch (e) {
        print("[ProfileCreationCubit] Erro ao completar perfil: $e");
        if (!isClosed) {
          emit(ProfileCreationError(e.toString()));
        }
      }
    }
  }
} 