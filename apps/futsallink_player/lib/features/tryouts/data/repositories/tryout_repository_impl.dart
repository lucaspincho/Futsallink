import '../../domain/models/tryout_details_model.dart';
import '../../domain/repositories/tryout_repository.dart';

class TryoutRepositoryImpl implements TryoutRepository {
  @override
  Future<TryoutDetailsModel> getTryoutDetails(String tryoutId) async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Retorna dados mockados
    return TryoutDetailsModel(
      id: tryoutId,
      clubId: '1',
      clubName: 'Sport Club do Recife',
      clubLogoUrl: '', // Será carregado como imagem local
      category: 'Sub 15',
      position: 'Fixo',
      description: '''
      Mostre seu talento sem sair de casa! A seletiva para a categoria Sub-15, posição Fixo, do Sport Club do Recife será totalmente virtual e está com inscrições abertas.

      Após se inscrever, você deverá enviar um vídeo com duração entre 3 e 5 minutos demonstrando suas habilidades na posição de Fixo. O material será analisado pela equipe técnica do clube.

      O vídeo deve conter:
      - Jogadas defensivas (marcação, cobertura)
      - Passes e posicionamento em quadra
      - Início de jogadas e controle de bola
      - Lances reais de partidas (se possível)

      Pré-requisitos:

      - Nascidos entre 2010 e 2011
      - Vídeo gravado na horizontal, com boa qualidade de áudio e imagem
      - Autorização dos pais ou responsáveis (se menor de idade)

      Os atletas aprovados na fase de vídeo serão contatados para as próximas etapas do processo seletivo. Prepare-se e boa sorte!
      ''',
      isOpen: true,
    );
  }
} 