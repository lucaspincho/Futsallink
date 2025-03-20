import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_player/features/profile/presentation/widgets/profile_steps.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:get_it/get_it.dart';

class ProfileCreationPage extends StatefulWidget {
  const ProfileCreationPage({Key? key}) : super(key: key);

  @override
  State<ProfileCreationPage> createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCreationCubit>(
      create: (_) => GetIt.instance<ProfileCreationCubit>()..initProfileCreation(),
      child: BlocConsumer<ProfileCreationCubit, ProfileCreationState>(
        listener: (context, state) {
          if (state is ProfileCreationSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
          
          if (state is ProfileCreationActive) {
            _pageController.animateToPage(
              state.currentStep,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileCreationLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is ProfileCreationError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Erro ao carregar perfil',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileCreationCubit>().initProfileCreation();
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProfileCreationActive) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Criar Perfil'),
                leading: state.currentStep > 0
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          context.read<ProfileCreationCubit>().goToPreviousStep();
                        },
                      )
                    : null,
              ),
              body: Column(
                children: [
                  // Indicador de progresso
                  LinearProgressIndicator(
                    value: state.currentStep / (state.totalSteps - 1),
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      FutsallinkColors.primary,
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ProfileWelcomeStep(),
                        ProfileNameStep(),
                        ProfileBirthdayStep(),
                        ProfilePositionStep(),
                        ProfileDominantFootStep(),
                        ProfileHeightWeightStep(),
                        ProfilePhotoStep(),
                        ProfileBioStep(),
                        ProfileTeamStep(),
                        ProfileConfirmationStep(),
                      ],
                    ),
                  ),
                  // Botão de navegação
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FutsallinkColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: state.isCurrentStepValid
                            ? () {
                                if (state.currentStep == state.totalSteps - 1) {
                                  context.read<ProfileCreationCubit>().completeProfile();
                                } else {
                                  context.read<ProfileCreationCubit>().goToNextStep();
                                }
                              }
                            : null,
                        child: state.isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                state.currentStep == state.totalSteps - 1
                                    ? 'Concluir'
                                    : 'Continuar',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: Text('Estado desconhecido'),
            ),
          );
        },
      ),
    );
  }
} 