import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:futsallink_player/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:futsallink_player/features/home/presentation/widgets/futsallink_header.dart';
import 'package:futsallink_player/features/home/presentation/widgets/section_header.dart';
import '../bloc/tryouts_cubit.dart';
import '../bloc/tryouts_state.dart';
import '../widgets/search_field_with_filter.dart';
import '../widgets/tryout_list_item.dart';

class TryoutsScreen extends StatefulWidget {
  final bool showBackButton;
  
  const TryoutsScreen({
    Key? key,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  State<TryoutsScreen> createState() => _TryoutsScreenState();
}

class _TryoutsScreenState extends State<TryoutsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NavItem _currentNavItem = NavItem.tryouts;

  @override
  void initState() {
    super.initState();
    context.read<TryoutsCubit>().loadTryouts();
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
    } else if (item == NavItem.clubs) {
      Navigator.pushReplacementNamed(context, '/clubs');
    } else if (item == NavItem.profile) {
      Navigator.pushReplacementNamed(context, '/profile');
    } else if (item == NavItem.chat) {
      // Implementar navegação para o chat quando estiver disponível
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
            // Header com logo e configurações
            FutsallinkHeader(
              isHomePage: true,
              onSettingsTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            
            // Título da seção "Seletivas"
            SectionHeader(
              title: 'Seletivas',
              onSeeMoreTap: null,
            ),
            
            // Conteúdo principal
            Expanded(
              child: BlocBuilder<TryoutsCubit, TryoutsState>(
                builder: (context, state) {
                  if (state is TryoutsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: FutsallinkColors.primary,
                      ),
                    );
                  } else if (state is TryoutsError) {
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
                              context.read<TryoutsCubit>().loadTryouts();
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
                  } else if (state is TryoutsLoaded) {
                    // Se estamos em um estado carregado, podemos acessar os dados
                    _searchController.text = state.searchQuery;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FutsallinkSpacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo de busca com filtro
                          SearchFieldWithFilter(
                            controller: _searchController,
                            onChanged: (query) {
                              context.read<TryoutsCubit>().searchTryouts(query);
                            },
                            onFilterTap: () {
                              // Função de filtro (não implementada ainda)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Filtro não implementado ainda'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            hintText: 'Pesquise peneiras',
                          ),
                          
                          const SizedBox(height: FutsallinkSpacing.lg),
                          
                          // Resultado da busca
                          if (state.searchQuery.isNotEmpty && state.filteredTryouts.isEmpty)
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
                                      'Nenhuma seletiva encontrada para "${state.searchQuery}"',
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
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  bottom: FutsallinkSpacing.xl,
                                ),
                                itemCount: state.filteredTryouts.length,
                                itemBuilder: (context, index) {
                                  final tryout = state.filteredTryouts[index];
                                  return TryoutListItem(
                                    tryout: tryout,
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