import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import '../bloc/tryout_details_cubit.dart';
import '../bloc/tryout_details_state.dart';
import '../widgets/back_header.dart';
import '../../domain/models/tryout_details_model.dart';

class TryoutDetailsScreen extends StatefulWidget {
  final String tryoutId;
  
  const TryoutDetailsScreen({
    Key? key,
    required this.tryoutId,
  }) : super(key: key);

  @override
  State<TryoutDetailsScreen> createState() => _TryoutDetailsScreenState();
}

class _TryoutDetailsScreenState extends State<TryoutDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TryoutDetailsCubit>().loadTryoutDetails(widget.tryoutId);
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
              child: BlocBuilder<TryoutDetailsCubit, TryoutDetailsState>(
                builder: (context, state) {
                  if (state is TryoutDetailsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: FutsallinkColors.primary,
                      ),
                    );
                  } else if (state is TryoutDetailsError) {
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
                                context.read<TryoutDetailsCubit>().loadTryoutDetails(widget.tryoutId);
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
                  } else if (state is TryoutDetailsLoaded) {
                    final tryout = state.tryoutDetails;
                    return _buildContent(tryout);
                  }
                  
                  // Estado inicial
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      // Botão de inscrição fixo na parte inferior
      bottomNavigationBar: BlocBuilder<TryoutDetailsCubit, TryoutDetailsState>(
        builder: (context, state) {
          if (state is TryoutDetailsLoaded) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FutsallinkSpacing.lg,
                vertical: FutsallinkSpacing.md,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF001528),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para inscrição na seletiva
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FutsallinkColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Se inscrever',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(TryoutDetailsModel tryout) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FutsallinkSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: FutsallinkSpacing.md),
            
            // Card com escudo e nome do clube
            Container(
              padding: const EdgeInsets.all(FutsallinkSpacing.md),
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
              child: Row(
                children: [
                  // Escudo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        _getClubLogoPath(tryout.clubName),
                        fit: BoxFit.contain,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(width: FutsallinkSpacing.md),
                  
                  // Informações do clube
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tryout.clubName,
                          style: FutsallinkTypography.subtitle1.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tryout.category} - ${tryout.position}',
                          style: FutsallinkTypography.body2.copyWith(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: FutsallinkSpacing.lg),
            
            // Descrição da seletiva
            Text(
              'Detalhes da seletiva',
              style: FutsallinkTypography.headline3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: FutsallinkSpacing.md),
            Text(
              tryout.description,
              style: FutsallinkTypography.body1.copyWith(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            
            // Espaço para o botão não sobrepor conteúdo
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
} 