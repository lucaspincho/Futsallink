import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:intl/intl.dart';

class ProfileConfirmationStep extends StatefulWidget {
  const ProfileConfirmationStep({Key? key}) : super(key: key);

  @override
  State<ProfileConfirmationStep> createState() => _ProfileConfirmationStepState();
}

class _ProfileConfirmationStepState extends State<ProfileConfirmationStep> {
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    // Esta etapa é sempre válida, pois é apenas de confirmação
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive && !state.isCurrentStepValid) {
      context.read<ProfileCreationCubit>().emit(state.copyWith(isCurrentStepValid: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCreationCubit, ProfileCreationState>(
      builder: (context, state) {
        if (state is ProfileCreationActive) {
          final player = state.player;

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Espaçamento para separar o conteúdo do AppBar
                        SizedBox(height: _calculateTopPadding(constraints.maxHeight)),
                        
                        const ScreenTitle(
                          text: 'CONFIRME SEUS DADOS',
                          bottomPadding: 8.0,
                        ),
                        
                        const SubtitleText(
                          text: 'Verifique se todas as informações estão corretas',
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Seção de perfil
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Foto de perfil
                            _buildProfileImage(player.profileImage),
                            const SizedBox(width: 16),
                            // Dados básicos
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.fullName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (player.nickname != null)
                                    Text(
                                      'Apelido: ${player.nickname}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Idade: ${player.age} anos',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  Text(
                                    'Posição: ${player.position}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  Text(
                                    'Pé dominante: ${player.dominantFoot}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 16),
                        // Informações detalhadas
                        _buildInfoSection('Dados Físicos', [
                          'Altura: ${player.height} cm',
                          'Peso: ${player.weight} kg',
                        ]),
                        const SizedBox(height: 16),
                        _buildInfoSection('Informações de Clube', [
                          'Time atual: ${player.currentTeam ?? "Não informado"}'
                        ]),
                        const SizedBox(height: 16),
                        if (player.bio != null && player.bio!.isNotEmpty)
                          _buildBioSection(player.bio!),
                        const SizedBox(height: 24),
                        // Card de confirmação com tema FutsalLink
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: FutsallinkColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: FutsallinkColors.primary),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, 
                                      color: FutsallinkColors.primary, 
                                      size: 26),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tudo pronto!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: FutsallinkColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Seu perfil está completo e pronto para ser criado. Clique em "Concluir" para finalizar.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Após a conclusão, você poderá editar seu perfil a qualquer momento.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        // Espaçamento extra no final
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const Center(
          child: Text(
            'Carregando dados do perfil...',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    final size = MediaQuery.of(context).size.width * 0.2;
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  color: FutsallinkColors.primary,
                ),
              );
            },
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: FutsallinkColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildBioSection(String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biografia',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: FutsallinkColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[600]!),
          ),
          child: Text(
            bio,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
      ],
    );
  }

  // Método para calcular o padding superior adequado
  double _calculateTopPadding(double screenHeight) {
    // Padding mínimo para telas pequenas
    const double minPadding = 24.0;
    
    // Padding proporcional à altura da tela (4% da altura)
    final proportionalPadding = screenHeight * 0.04;
    
    // Usa o maior valor entre o mínimo e o proporcional
    return proportionalPadding > minPadding ? proportionalPadding : minPadding;
  }
} 