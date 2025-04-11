import 'package:futsallink_player/features/home/domain/models/tryout_model.dart';
import '../../domain/models/club_details_model.dart';
import '../../domain/repositories/club_repository.dart';

class ClubRepositoryImpl implements ClubRepository {
  @override
  Future<ClubDetailsModel> getClubDetails(String clubId) async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock de seletivas do clube
    final mockTryouts = [
      TryoutModel(
        id: '1',
        clubId: clubId,
        clubName: 'Sport Club do Recife',
        clubLogoUrl: '',
        category: 'Sub-15',
        position: 'Fixo',
        isOpen: true,
      ),
      TryoutModel(
        id: '2',
        clubId: clubId,
        clubName: 'Sport Club do Recife',
        clubLogoUrl: '',
        category: 'Sub-17',
        position: 'Ala',
        isOpen: true,
      ),
      TryoutModel(
        id: '3',
        clubId: clubId,
        clubName: 'Sport Club do Recife',
        clubLogoUrl: '',
        category: 'Sub-20',
        position: 'Goleiro',
        isOpen: true,
      ),
    ];
    
    // Retorna dados mockados
    return ClubDetailsModel(
      id: clubId,
      name: 'Sport Club do Recife',
      logoUrl: '', // Será carregado como imagem local
      description: '''
      Fundado em 1905, o Sport Club do Recife é um dos clubes mais tradicionais e respeitados do Nordeste brasileiro. Com uma história rica em conquistas e uma torcida apaixonada, o Leão da Ilha mantém viva a chama da competitividade em todas as modalidades que representa, incluindo o futsal.

      Nosso compromisso é formar atletas com excelência técnica, disciplina e espírito de equipe. Aqui, valorizamos o talento, mas também o esforço e a dedicação de cada jogador que veste o manto rubro-negro.

      Participe das nossas seletivas, mostre seu potencial e venha fazer parte dessa história!
      ''',
      categories: ['Sub-15', 'Sub-17', 'Sub-20'],
      positions: ['Fixo', 'Ala', 'Goleiro'],
      tryouts: mockTryouts,
    );
  }
} 