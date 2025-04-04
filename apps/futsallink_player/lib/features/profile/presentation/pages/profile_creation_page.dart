import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_player/features/profile/presentation/widgets/profile_steps.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:futsallink_ui/components/header/futsallink_logo_header.dart';
import 'package:get_it/get_it.dart';

class ProfileCreationPage extends StatefulWidget {
  final User? user;
  final int? lastCompletedStep;

  const ProfileCreationPage({
    Key? key, 
    this.user,
    this.lastCompletedStep,
  }) : super(key: key);

  @override
  State<ProfileCreationPage> createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final PageController _pageController = PageController(initialPage: 0);
  late final ProfileCreationCubit _profileCreationCubit;

  @override
  void initState() {
    super.initState();
    print("[ProfileCreationPage] initState chamado");
    _profileCreationCubit = GetIt.instance<ProfileCreationCubit>();
    
    // Atrasar a inicialização para garantir que o widget esteja montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print("[ProfileCreationPage] Post frame callback - iniciando cubit");
        _profileCreationCubit.initProfileCreation(widget.user);
      }
    });
  }

  @override
  void dispose() {
    print("[ProfileCreationPage] dispose chamado");
    _pageController.dispose();
    // Não fechamos o cubit aqui, pois ele é gerenciado pelo GetIt
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("[ProfileCreationPage] build chamado");
    
    return BlocProvider<ProfileCreationCubit>.value(
      value: _profileCreationCubit,
      child: BlocConsumer<ProfileCreationCubit, ProfileCreationState>(
        listener: (context, state) {
          print("[ProfileCreationPage] BlocConsumer listener: estado ${state.runtimeType}");
          
          if (state is ProfileCreationSuccess) {
            print("[ProfileCreationPage] Perfil criado com sucesso, redirecionando para home");
            Navigator.of(context).pushReplacementNamed('/home');
          }
          
          if (state is ProfileCreationActive) {
            // Garantir que o PageView esteja disponível antes de animar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _pageController.hasClients) {
                print("[ProfileCreationPage] Animando para o passo ${state.currentStep}");
                _pageController.animateToPage(
                  state.currentStep,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          }
        },
        builder: (context, state) {
          print("[ProfileCreationPage] BlocConsumer builder: estado ${state.runtimeType}");
          
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
                        _profileCreationCubit.initProfileCreation(widget.user);
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
              backgroundColor: FutsallinkColors.darkBackground,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Padding(
                  padding: const EdgeInsets.only(top: 26.0),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    leading: state.currentStep > 0
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              _profileCreationCubit.goToPreviousStep();
                            },
                          )
                        : null,
                    title: const Center(
                      child: FutsallinkLogoHeader(
                        logoHeight: 28.0,
                        verticalPadding: 16.0,
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      // Widget transparente para balancear o botão voltar
                      state.currentStep > 0
                          ? const SizedBox(width: 48)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
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
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
                    child: PrimaryButton(
                      text: state.currentStep == state.totalSteps - 1
                          ? 'CONCLUIR'
                          : 'AVANÇAR',
                      onPressed: state.isCurrentStepValid
                          ? () {
                              if (state.currentStep == state.totalSteps - 1) {
                                _profileCreationCubit.completeProfile();
                              } else {
                                _profileCreationCubit.goToNextStep();
                              }
                            }
                          : null,
                      isLoading: state.isSubmitting,
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