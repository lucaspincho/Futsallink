import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import '../bloc/club_details_cubit.dart';
import '../bloc/club_details_state.dart';
import '../widgets/tryout_grid_item.dart';
import '../../domain/models/club_details_model.dart';
import 'package:futsallink_player/features/tryouts/presentation/widgets/back_header.dart';
import 'package:futsallink_player/features/home/presentation/widgets/bottom_nav_bar.dart';

class ClubDetailsScreen extends StatefulWidget {
  final String clubId;
  
  const ClubDetailsScreen({
    Key? key,
    required this.clubId,
  }) : super(key: key);

  @override
  State<ClubDetailsScreen> createState() => _ClubDetailsScreenState();
}

class _ClubDetailsScreenState extends State<ClubDetailsScreen> {
  final NavItem _currentNavItem = NavItem.clubs;

  @override
  void initState() {
    super.initState();
    context.read<ClubDetailsCubit>().loadClubDetails(widget.clubId);
  }

  // Função para obter o caminho da imagem do escudo com base no nome do clube
  String _getClubLogoPath(String clubName) {
    final clubNameLower = clubName.toLowerCase();
    
    if (clubNameLower.contains('sport')) {
      return 'assets/images/escudos/sport.png';
    } else if (clubNameLower.contains('corinthians')) {
      return 'assets/images/escudos/corinthians.png';
    } else if (clubNameLower.contains('américa') || clubNameLower.contains('america')) {
      return 'assets/images/escudos/america_mineiro.png';
    } else if (clubNameLower.contains('náutico') || clubNameLower.contains('nautico')) {
      return 'assets/images/escudos/nautico.png';
    } else if (clubNameLower.contains('bahia')) {
      return 'assets/images/escudos/bahia.png';
    } else if (clubNameLower.contains('santa cruz')) {
      return 'assets/images/escudos/santa_cruz.png';
    } else if (clubNameLower.contains('joinville')) {
      return 'assets/images/escudos/joinville.png';
    } else if (clubNameLower.contains('goiás') || clubNameLower.contains('goias')) {
      return 'assets/images/escudos/goias.png';
    } else if (clubNameLower.contains('atlântico') || clubNameLower.contains('atlantico')) {
      return 'assets/images/escudos/atlantico_erechim.png';
    }
    
    // Escudo padrão se não encontrar correspondência
    return 'assets/images/escudos/sport.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001528),
      body: SafeArea(
        child: Column(
          children: [
            // Header com botão de voltar
            BackHeader(
              onBackTap: () => Navigator.of(context).pop(),
            ),
            
            // Conteúdo principal com scroll
            Expanded(
              child: BlocBuilder<ClubDetailsCubit, ClubDetailsState>(
                builder: (context, state) {
                  if (state is ClubDetailsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: FutsallinkColors.primary,
                      ),
                    );
                  } else if (state is ClubDetailsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(FutsallinkSpacing.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: FutsallinkSpacing.md),
                            Text(
                              state.message,
                              style: FutsallinkTypography.body1.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: FutsallinkSpacing.lg),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ClubDetailsCubit>().loadClubDetails(widget.clubId);
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
                      ),
                    );
                  } else if (state is ClubDetailsLoaded) {
                    final club = state.clubDetails;
                    return _buildContent(club);
                  }
                  
                  // Estado inicial
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentItem: _currentNavItem,
        onItemSelected: (item) {
          if (item != _currentNavItem) {
            // Navegar para a página correspondente
            if (item == NavItem.home) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          }
        },
      ),
    );
  }

  Widget _buildContent(ClubDetailsModel club) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FutsallinkSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: FutsallinkSpacing.lg),
            
            // Escudo do clube
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  _getClubLogoPath(club.name),
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            const SizedBox(height: FutsallinkSpacing.lg),
            
            // Nome do clube
            Text(
              club.name,
              style: FutsallinkTypography.headline2.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: FutsallinkSpacing.lg),
            
            // Descrição do clube
            Text(
              club.description,
              style: FutsallinkTypography.body1.copyWith(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            
            const SizedBox(height: FutsallinkSpacing.xl),
            
            // Título da seção de seletivas
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Seleções disponíveis',
                style: FutsallinkTypography.headline3.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: FutsallinkSpacing.md),
            
            // Lista horizontal de seletivas
            SizedBox(
              height: 240,
              child: club.tryouts.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma seletiva disponível no momento.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: club.tryouts.length,
                      itemBuilder: (context, index) {
                        final tryout = club.tryouts[index];
                        return TryoutGridItem(
                          tryout: tryout,
                          inscritosCount: 12 + index, // Mock para variar o número
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/tryout-details',
                              arguments: tryout.id,
                            );
                          },
                        );
                      },
                    ),
            ),
            
            // Espaço inferior
            const SizedBox(height: FutsallinkSpacing.xl),
          ],
        ),
      ),
    );
  }
} 