import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  final GetPlayer getPlayer;
  final PlayerRepository playerRepository;
  final GetCurrentUserUseCase getCurrentUser;
  final ImagePicker _imagePicker = ImagePicker();

  ProfileEditCubit({
    required this.getPlayer,
    required this.playerRepository,
    required this.getCurrentUser,
  }) : super(ProfileEditInitial());

  Future<void> loadProfile() async {
    emit(ProfileEditLoading());

    try {
      final userResult = await getCurrentUser();
      
      await userResult.fold(
        (failure) {
          emit(ProfileEditError(failure.toString()));
        },
        (user) async {
          if (user == null) {
            emit(ProfileEditError('Usuário não encontrado'));
            return;
          }
          
          final playerResult = await getPlayer(GetPlayerParams(uid: user.uid));
          
          playerResult.fold(
            (failure) {
              emit(ProfileEditError(failure.toString()));
            },
            (player) {
              emit(ProfileEditLoaded(player: player, isUpdating: false));
            },
          );
        },
      );
    } catch (e) {
      emit(ProfileEditError('Erro inesperado: $e'));
    }
  }

  Future<void> pickImage() async {
    if (state is ProfileEditLoaded) {
      try {
        final currentState = state as ProfileEditLoaded;
        final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
        
        if (pickedFile != null) {
          final imageFile = File(pickedFile.path);
          emit(currentState.copyWith(selectedImage: imageFile));
        }
      } catch (e) {
        emit(ProfileEditError('Erro ao selecionar imagem: $e'));
      }
    }
  }

  Future<void> saveChanges({
    required String firstName,
    required String lastName,
    String? nickname,
    required String position,
    required String dominantFoot,
    String? bio,
    required DateTime birthday,
    required int height,
    required double weight,
    String? currentTeam,
  }) async {
    if (state is ProfileEditLoaded) {
      final currentState = state as ProfileEditLoaded;
      final currentPlayer = currentState.player;
      
      emit(currentState.copyWith(isUpdating: true));
      
      try {
        // Criar player atualizado
        final updatedPlayer = (currentPlayer as dynamic).copyWith(
          firstName: firstName,
          lastName: lastName,
          nickname: nickname,
          position: position,
          dominantFoot: dominantFoot,
          bio: bio,
          birthday: birthday,
          height: height,
          weight: weight,
          currentTeam: currentTeam,
          updatedAt: DateTime.now(),
        );
        
        // Fazer upload da imagem se uma nova foi selecionada
        String? photoUrl = currentPlayer.profileImage;
        
        if (currentState.selectedImage != null) {
          final imageResult = await playerRepository.uploadProfileImage(
            currentPlayer.uid,
            currentState.selectedImage!
          );
          
          await imageResult.fold(
            (failure) {
              // Continuar mesmo com falha no upload da imagem
              print('Falha ao fazer upload da imagem: ${failure.toString()}');
            },
            (url) {
              photoUrl = url;
            },
          );
        }
        
        // Adicionar URL da foto ao player atualizado
        final playerWithPhoto = (updatedPlayer as dynamic).copyWith(
          profileImage: photoUrl,
        );
        
        // Salvar player atualizado
        final result = await playerRepository.updatePlayer(playerWithPhoto);
        
        result.fold(
          (failure) {
            emit(ProfileEditError(failure.toString()));
          },
          (updatedPlayerResult) {
            emit(ProfileEditSuccess(updatedPlayerResult));
          },
        );
      } catch (e) {
        emit(ProfileEditError('Erro ao salvar alterações: $e'));
      }
    }
  }
} 