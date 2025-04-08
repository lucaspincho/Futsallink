import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/club_grid_item.dart';
import '../widgets/futsallink_header.dart';
import '../widgets/section_header.dart';
import '../widgets/tryout_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavItem _currentNavItem = NavItem.home;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  void _onNavItemSelected(NavItem item) {
    setState(() {
      _currentNavItem = item;
    });
    // Aqui você pode implementar a navegação para outras telas
  }

  void _onSettingsTap() {
    // Navegar para a tela de configurações
    Navigator.pushNamed(context, '/settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FutsallinkColors.darkBackground,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading && state.clubs.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(FutsallinkColors.primary),
                ),
              );
            }

            if (state.status == HomeStatus.error) {
              return Center(
                child: Text(
                  'Erro ao carregar dados: ${state.errorMessage}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // Header com logo e ícone de configurações
                SliverToBoxAdapter(
                  child: FutsallinkHeader(
                    onSettingsTap: _onSettingsTap,
                  ),
                ),

                // Seção de Seletivas
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Seletivas',
                    onSeeMoreTap: () {
                      // Navegar para a página de todas as seletivas
                    },
                  ),
                ),

                // Lista horizontal de cards de seletivas
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 260,
                    child: state.tryouts.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhuma seletiva disponível no momento.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.tryouts.length,
                            itemBuilder: (context, index) {
                              final tryout = state.tryouts[index];
                              return TryoutCard(
                                tryout: tryout,
                                onTap: () {
                                  // Navegar para a página de detalhes da seletiva
                                },
                              );
                            },
                          ),
                  ),
                ),

                // Seção de Clubes
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Clubes',
                    onSeeMoreTap: () {
                      // Navegar para a página de todos os clubes
                    },
                  ),
                ),

                // Grid de clubes
                SliverPadding(
                  padding: const EdgeInsets.all(FutsallinkSpacing.md),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= state.clubs.length) {
                          return null;
                        }
                        final club = state.clubs[index];
                        return ClubGridItem(
                          club: club,
                          onTap: () {
                            // Navegar para a página de detalhes do clube
                          },
                        );
                      },
                      childCount: state.clubs.length > 8 ? 8 : state.clubs.length,
                    ),
                  ),
                ),

                // Espaço para a barra de navegação
                const SliverToBoxAdapter(
                  child: SizedBox(height: 70),
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
} 