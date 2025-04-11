import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:futsallink_player/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:futsallink_player/features/home/presentation/widgets/club_grid_item.dart';
import 'package:futsallink_player/features/home/presentation/widgets/section_header.dart';
import 'package:futsallink_player/features/tryouts/presentation/widgets/back_header.dart';
import '../bloc/clubs_cubit.dart';
import '../bloc/clubs_state.dart';
import '../widgets/search_field.dart';

class ClubsScreen extends StatefulWidget {
  final bool showBackButton;
  
  const ClubsScreen({
    Key? key,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NavItem _currentNavItem = NavItem.clubs;

  @override
  void initState() {
    super.initState();
    context.read<ClubsCubit>().loadClubs();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavItemSelected(NavItem item) {
    if (item == _currentNavItem) return;
    
    // Navegar para a tela correspondente
    if (item == NavItem.home) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001528),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com logo e botão de voltar
            BackHeader(
              onBackTap: widget.showBackButton 
                ? () => Navigator.of(context).pop() 
                : null,
            ),
            
            // Título da seção "Clubes"
            SectionHeader(
              title: 'Clubes',
              onSeeMoreTap: null,
            ),
            
            // Conteúdo principal
            Expanded(
              child: BlocBuilder<ClubsCubit, ClubsState>(
                builder: (context, state) {
                  if (state is ClubsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: FutsallinkColors.primary,
                      ),
                    );
                  } else if (state is ClubsError) {
                    return Center(
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: FutsallinkSpacing.lg),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ClubsCubit>().loadClubs();
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
                  } else if (state is ClubsLoaded) {
                    // Se estamos em um estado carregado, podemos acessar os dados
                    _searchController.text = state.searchQuery;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FutsallinkSpacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo de busca
                          SearchField(
                            controller: _searchController,
                            onChanged: (query) {
                              context.read<ClubsCubit>().searchClubs(query);
                            },
                            hintText: 'Pesquise clubes',
                          ),
                          
                          const SizedBox(height: FutsallinkSpacing.lg),
                          
                          // Resultado da busca
                          if (state.searchQuery.isNotEmpty && state.filteredClubs.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: FutsallinkSpacing.xl),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      color: Colors.white.withOpacity(0.6),
                                      size: 48,
                                    ),
                                    const SizedBox(height: FutsallinkSpacing.md),
                                    Text(
                                      'Nenhum clube encontrado para "${state.searchQuery}"',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.only(
                                  bottom: FutsallinkSpacing.xl,
                                ),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1,
                                ),
                                itemCount: state.filteredClubs.length,
                                itemBuilder: (context, index) {
                                  final club = state.filteredClubs[index];
                                  return ClubGridItem(
                                    club: club,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/club-details',
                                        arguments: club.id,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
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
        onItemSelected: _onNavItemSelected,
      ),
    );
  }
} 