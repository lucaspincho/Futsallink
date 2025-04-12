import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:futsallink_player/features/home/presentation/widgets/futsallink_header.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import '../cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final NavItem _currentNavItem = NavItem.profile;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  void _onNavItemSelected(NavItem item) {
    if (item == _currentNavItem) return;
    
    // Navegar para a tela correspondente
    if (item == NavItem.home) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (item == NavItem.tryouts) {
      Navigator.pushReplacementNamed(context, '/tryouts');
    } else if (item == NavItem.clubs) {
      Navigator.pushReplacementNamed(context, '/clubs');
    } else if (item == NavItem.chat) {
      // Implementar navegação para o chat quando estiver disponível
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001528),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header com logo e configurações
                FutsallinkHeader(
                  isHomePage: true,
                  onSettingsTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                
                // Conteúdo principal
                Expanded(
                  child: _buildContent(state),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentItem: _currentNavItem,
        onItemSelected: _onNavItemSelected,
      ),
    );
  }

  Widget _buildContent(ProfileState state) {
    if (state is ProfileLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: FutsallinkColors.primary,
        ),
      );
    } else if (state is ProfileError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: FutsallinkColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar perfil',
              style: FutsallinkTypography.headline3.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: FutsallinkTypography.body2.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileCubit>().loadProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FutsallinkColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: FutsallinkSpacing.lg,
                  vertical: FutsallinkSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    } else if (state is ProfileLoaded) {
      final player = state.player;
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: FutsallinkSpacing.lg,
          vertical: FutsallinkSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Perfil do jogador (foto, nome e posição)
            _buildProfileHeader(player),
            
            const SizedBox(height: 24),
            
            // Botão Editar perfil
            _buildEditProfileButton(),
            
            const SizedBox(height: 24),
            
            // Biografia (se existir)
            if (player.bio != null && player.bio!.isNotEmpty)
              _buildBiographySection(player.bio!),
              
            const SizedBox(height: 24),
            
            // Informações detalhadas
            _buildDetailsSection(player),
            
            const SizedBox(height: 32),
            
            // Seção de destaques
            _buildHighlightsSection(),
            
            // Espaço para o bottom navigation bar não cobrir conteúdo
            const SizedBox(height: 40),
          ],
        ),
      );
    }

    // Estado inicial
    return const SizedBox.shrink();
  }

  Widget _buildProfileHeader(Player player) {
    return Container(
      padding: const EdgeInsets.all(FutsallinkSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF001E3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Foto de perfil
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: player.profileImage != null && player.profileImage!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      player.profileImage!,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
          ),
          const SizedBox(width: 16),
          // Nome e posição
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${player.firstName} ${player.lastName}',
                  style: FutsallinkTypography.headline3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  player.position,
                  style: FutsallinkTypography.body1.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton(
      onPressed: () {
        // Ação será implementada posteriormente
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: FutsallinkColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Editar perfil',
        style: FutsallinkTypography.button.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBiographySection(String bio) {
    return Container(
      padding: const EdgeInsets.all(FutsallinkSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF001E3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biografia',
            style: FutsallinkTypography.headline3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            bio,
            style: FutsallinkTypography.body2.copyWith(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(Player player) {
    return Container(
      padding: const EdgeInsets.all(FutsallinkSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF001E3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Idade
          _buildDetailItem('Idade', '${player.age} anos'),
          
          // Nacionalidade
          _buildDetailItem('Nacionalidade', 'Brasileiro'),
          
          // Pé dominante
          _buildDetailItem('Pé dominante', player.dominantFoot),
          
          // Altura (se disponível)
          if (player.height > 0)
            _buildDetailItem('Altura', '${player.height} cm'),
          
          // Peso (se disponível)
          if (player.weight > 0)
            _buildDetailItem('Peso', '${player.weight.toStringAsFixed(1)} kg'),
          
          // Time atual (se disponível)
          if (player.currentTeam != null && player.currentTeam!.isNotEmpty)
            _buildDetailItem('Time atual', player.currentTeam!),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: FutsallinkTypography.subtitle1.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: FutsallinkTypography.subtitle1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Divider para todos exceto o último item
        Divider(
          color: Colors.grey.withOpacity(0.2),
          height: 1,
        ),
      ],
    );
  }

  Widget _buildHighlightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Destaques',
          style: FutsallinkTypography.headline3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF001E3C),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: 48,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 