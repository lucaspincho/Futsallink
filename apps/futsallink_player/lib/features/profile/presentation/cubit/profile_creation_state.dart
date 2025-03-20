part of 'profile_creation_cubit.dart';

abstract class ProfileCreationState extends Equatable {
  const ProfileCreationState();

  @override
  List<Object?> get props => [];
}

class ProfileCreationInitial extends ProfileCreationState {}

class ProfileCreationLoading extends ProfileCreationState {}

class ProfileCreationActive extends ProfileCreationState {
  final int currentStep;
  final Player player;
  final int totalSteps;
  final bool isCurrentStepValid;
  final bool isSubmitting;
  final bool isUploading;
  final String? errorMessage;

  const ProfileCreationActive({
    required this.currentStep,
    required this.player,
    required this.totalSteps,
    this.isCurrentStepValid = false,
    this.isSubmitting = false,
    this.isUploading = false,
    this.errorMessage,
  });

  ProfileCreationActive copyWith({
    int? currentStep,
    Player? player,
    int? totalSteps,
    bool? isCurrentStepValid,
    bool? isSubmitting,
    bool? isUploading,
    String? errorMessage,
  }) {
    return ProfileCreationActive(
      currentStep: currentStep ?? this.currentStep,
      player: player ?? this.player,
      totalSteps: totalSteps ?? this.totalSteps,
      isCurrentStepValid: isCurrentStepValid ?? this.isCurrentStepValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isUploading: isUploading ?? this.isUploading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        player,
        totalSteps,
        isCurrentStepValid,
        isSubmitting,
        isUploading,
        errorMessage,
      ];
}

class ProfileCreationError extends ProfileCreationState {
  final String message;

  const ProfileCreationError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileCreationSuccess extends ProfileCreationState {
  final Player player;

  const ProfileCreationSuccess(this.player);

  @override
  List<Object?> get props => [player];
} 