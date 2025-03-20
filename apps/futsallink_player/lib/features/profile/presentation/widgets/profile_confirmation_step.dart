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

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirme seus dados',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Verifique se todas as informações estão corretas antes de finalizar',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
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
                              ),
                            ),
                            if (player.nickname != null)
                              Text(
                                'Apelido: ${player.nickname}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              'Idade: ${player.age} anos',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Posição: ${player.position}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Pé dominante: ${player.dominantFoot}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'Tudo pronto!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Seu perfil está completo e pronto para ser criado. Clique em "Concluir" para finalizar.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Após a conclusão, você poderá editar seu perfil a qualquer momento.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(
          child: Text('Carregando dados do perfil...'),
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
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                item,
                style: const TextStyle(fontSize: 16),
              ),
            )),
      ],
    );
  }

  Widget _buildBioSection(String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Biografia',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            bio,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
} 