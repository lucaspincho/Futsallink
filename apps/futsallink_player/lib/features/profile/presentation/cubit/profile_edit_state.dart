part of 'profile_edit_cubit.dart';

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object?> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}

class ProfileEditLoading extends ProfileEditState {}

class ProfileEditLoaded extends ProfileEditState {
  final Player player;
  final bool isUpdating;
  final File? selectedImage;

  const ProfileEditLoaded({
    required this.player,
    required this.isUpdating,
    this.selectedImage,
  });

  ProfileEditLoaded copyWith({
    Player? player,
    bool? isUpdating,
    File? selectedImage,
  }) {
    return ProfileEditLoaded(
      player: player ?? this.player,
      isUpdating: isUpdating ?? this.isUpdating,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }

  @override
  List<Object?> get props => [player, isUpdating, selectedImage];
}

class ProfileEditError extends ProfileEditState {
  final String message;

  const ProfileEditError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileEditSuccess extends ProfileEditState {
  final Player player;

  const ProfileEditSuccess(this.player);

  @override
  List<Object?> get props => [player];
} 