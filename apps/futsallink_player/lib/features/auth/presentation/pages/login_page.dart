// Em apps/futsallink_player/lib/features/auth/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_player/features/profile/data/repositories/player_repository_impl.dart';
import 'package:futsallink_player/core/di/injection_container.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final PlayerRepository _playerRepository = sl<PlayerRepository>();

  @override
  void initState() {
    super.initState();
    
    // Verificar o estado atual do AuthBloc logo após a inicialização
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      print('[LoginPage] Estado inicial do AuthBloc: ${authState.runtimeType}');
      
      // Verificar novamente após um curto delay (fallback)
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        final currentState = context.read<AuthBloc>().state;
        print('[LoginPage] Estado do AuthBloc após delay: ${currentState.runtimeType}');
        
        if (currentState is ProfileNotFoundState) {
          print('[LoginPage] Redirecionando para criação de perfil via fallback');
          navigateToProfile(currentState.user);
        } else if (currentState is ProfileCreationRequiredState) {
          print('[LoginPage] Redirecionando para completar perfil via fallback');
          navigateToProfileCompletion(currentState.user, currentState.lastCompletedStep);
        } else if (currentState is ProfileCompleteState) {
          print('[LoginPage] Redirecionando para home via fallback');
          navigateToHome();
        } else if (currentState is AuthenticatedState && currentState.user != null) {
          print('[LoginPage] Estado AuthenticatedState detectado, verificando perfil diretamente');
          onLoginSuccess(currentState.user);
        }
      });
    });
  }

  void onLoginSuccess(User user) {
    print("[LoginPage] onLoginSuccess chamado para usuário: ${user.uid}");
    
    // Verificar diretamente o status do perfil
    _playerRepository.getProfileCompletionStatus(user.uid).then((result) {
      print("[LoginPage] Verificação direta do status do perfil concluída");
      
      result.fold(
        (failure) {
          print("[LoginPage] Falha na verificação direta: ${failure.message}");
          // Assume que se houver falha, o perfil não existe
          print("[LoginPage] Redirecionando para criação de perfil após falha");
          navigateToProfile(user);
        },
        (status) {
          print("[LoginPage] Status do perfil: $status");
          
          if (status == ProfileCompletionStatus.none) {
            print("[LoginPage] Redirecionando para criação de perfil (verificação direta)");
            navigateToProfile(user);
          } else if (status == ProfileCompletionStatus.partial) {
            print("[LoginPage] Redirecionando para continuação de perfil (verificação direta)");
            navigateToProfileCompletion(user, -1);
          } else {
            print("[LoginPage] Redirecionando para home (verificação direta)");
            navigateToHome();
          }
        },
      );
    }).catchError((error) {
      print("[LoginPage] Erro na verificação direta: $error");
      // Assume que se houver erro, provavelmente o perfil não existe
      print("[LoginPage] Redirecionando para criação de perfil após erro");
      navigateToProfile(user);
    });
  }
  
  void navigateToProfile(User user) {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/profile/create', 
          arguments: {'user': user});
    }
  }
  
  void navigateToProfileCompletion(User user, int lastCompletedStep) {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/profile/complete', 
          arguments: {'user': user, 'lastCompletedStep': lastCompletedStep});
    }
  }
  
  void navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Log para verificar se o build do widget está sendo chamado
    print('[LoginPage] Construindo LoginPage widget');
    
    return Scaffold(
      backgroundColor: FutsallinkColors.darkBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          // Log para verificar mudanças de estado
          print('[LoginPage] BlocConsumer: mudança de estado de ${previous.runtimeType} para ${current.runtimeType}');
          // Sempre ouvir todas as mudanças de estado
          return true;
        },
        listener: (context, state) {
          print('[LoginPage] BlocConsumer listener chamado com estado: ${state.runtimeType}');
          
          if (state is AuthErrorState) {
            print('[LoginPage] Erro de autenticação: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProfileNotFoundState) {
            print('[LoginPage] Estado ProfileNotFoundState recebido - redirecionando para criação de perfil');
            navigateToProfile(state.user);
          } else if (state is ProfileCreationRequiredState) {
            print('[LoginPage] Estado ProfileCreationRequiredState recebido - redirecionando para completar perfil');
            navigateToProfileCompletion(state.user, state.lastCompletedStep);
          } else if (state is ProfileCompleteState) {
            print('[LoginPage] Estado ProfileCompleteState recebido - redirecionando para home');
            navigateToHome();
          } else if (state is AuthenticatedState) {
            // Apenas logando a autenticação bem-sucedida
            // O evento CheckProfileStatusEvent já foi adicionado ao BloC
            print('[LoginPage] Estado AuthenticatedState recebido - aguardando verificação de perfil');
          } else if (state is AuthLoading) {
            print('[LoginPage] Estado AuthLoading recebido - exibindo indicador de carregamento');
          } else {
            print('[LoginPage] Outro estado recebido: ${state.runtimeType}');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(FutsallinkSpacing.md),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: FutsallinkSpacing.lg),
                    const CustomLogoHeader(),
                    const SizedBox(height: FutsallinkSpacing.xl),
                    Text(
                      'LOGIN',
                      style: FutsallinkTypography.headline1.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Para acessar a plataforma coloque suas informações de login',
                      style: FutsallinkTypography.headline2.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: FutsallinkSpacing.xl),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'E-mail ou telefone',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: FutsallinkSpacing.md),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Senha',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomLink(
                        text: 'Esqueceu sua senha?',
                        onPressed: () {
                          Navigator.of(context).pushNamed('/forgot-password');
                        },
                      ),
                    ),
                    const SizedBox(height: FutsallinkSpacing.lg),
                    PrimaryButton(
                      text: 'ENTRAR',
                      isLoading: state is AuthLoading,
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                    LoginWithEmailPasswordEvent(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    ),
                                  );
                            },
                    ),
                    const SizedBox(height: FutsallinkSpacing.sm),
                    // Botão para debug
                    if (state is AuthenticatedState && state.user != null)
                      ElevatedButton(
                        onPressed: () {
                          print("[LoginPage] Forçando verificação para usuário atual via evento");
                          context.read<AuthBloc>().add(CheckProfileStatusEvent(user: state.user));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text("Debug: Forçar CheckProfileStatusEvent"),
                      ),
                    const SizedBox(height: FutsallinkSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tem uma conta? ',
                          style: FutsallinkTypography.headline2.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        CustomLink(
                          text: 'Crie aqui',
                          onPressed: () {
                            Navigator.of(context).pushNamed('/email-verification');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}