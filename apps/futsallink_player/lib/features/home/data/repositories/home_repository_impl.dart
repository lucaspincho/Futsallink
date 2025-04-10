import '../../domain/models/club_model.dart';
import '../../domain/models/tryout_model.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<List<ClubModel>> getClubs() async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Retorna dados mockados
    return [
      ClubModel(
        id: '1',
        name: 'Sport Club do Recife',
        logoUrl: '', // Será carregado como imagem local
        categories: ['Sub-15'],
        positions: ['Fixo'],
        hasTryouts: true,
      ),
      ClubModel(
        id: '2',
        name: 'América MG',
        logoUrl: '', // Será carregado como imagem local
        categories: ['Sub-15'],
        positions: ['Fixo'],
        hasTryouts: true,
      ),
      ClubModel(
        id: '3',
        name: 'Corinthians',
        logoUrl: '', // Será carregado como imagem local
        categories: ['Sub-17'],
        positions: ['Pivô'],
        hasTryouts: true,
      ),
      ClubModel(
        id: '4',
        name: 'Náutico',
        logoUrl: '', // Será carregado como imagem local
        categories: ['Sub-17'],
        positions: ['Ala'],
        hasTryouts: true,
      ),
      ClubModel(
        id: '5',
        name: 'Bahia',
        logoUrl: '', // Será carregado como imagem local
        categories: ['Sub-17'],
        positions: ['Ala'],
        hasTryouts: false,
      ),
      ClubModel(
        id: '6',
        name: 'Santa Cruz',
        logoUrl: '', // Será carregado como imagem local
        categories: ['Sub-17'],
        positions: ['Goleiro'],
        hasTryouts: false,
      ),
      ClubModel(
        id: '7',
        name: 'Goiás',
        logoUrl: '', // Será carregado como imagem local
        categories: ['Sub-15'],
        positions: ['Ala'],
        hasTryouts: false,
      ),
      ClubModel(
        id: '8',
        name: 'Atlântico Erechim',
        logoUrl: '', // Será carregado como imagem local
        categories: ['Sub-20'],
        positions: ['Ala'],
        hasTryouts: false,
      ),
    ];
  }

  @override
  Future<List<TryoutModel>> getTryouts() async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Retorna dados mockados
    return [
      TryoutModel(
        id: '1',
        clubId: '1',
        clubName: 'Sport Club do Recife',
        clubLogoUrl: '', // Será carregado como imagem local
        category: 'Sub-15',
        position: 'Fixo',
        isOpen: true,
      ),
      TryoutModel(
        id: '2',
        clubId: '2',
        clubName: 'América MG',
        clubLogoUrl: '', // Será carregado como imagem local
        category: 'Sub-15',
        position: 'Fixo',
        isOpen: true,
      ),
      TryoutModel(
        id: '3',
        clubId: '3',
        clubName: 'Corinthians',
        clubLogoUrl: '', // Será carregado como imagem local
        category: 'Sub-17',
        position: 'Pivô',
        isOpen: true,
      ),
      TryoutModel(
        id: '4',
        clubId: '4',
        clubName: 'Náutico',
        clubLogoUrl: '', // Será carregado como imagem local
        category: 'Sub-17',
        position: 'Ala',
        isOpen: true,
      ),
    ];
  }
} 