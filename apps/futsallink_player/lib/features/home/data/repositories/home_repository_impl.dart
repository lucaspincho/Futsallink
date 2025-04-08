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
        name: 'ABC F.C.',
        logoUrl: 'https://via.placeholder.com/150/FFFF00/000000?text=ABC',
        categories: ['Sub-15'],
        positions: ['Fixo'],
        hasTryouts: true,
      ),
      ClubModel(
        id: '2',
        name: 'América F.C.',
        logoUrl: 'https://via.placeholder.com/150/008000/FFFFFF?text=AME',
        categories: ['Sub-15'],
        positions: ['Fixo'],
        hasTryouts: true,
      ),
      ClubModel(
        id: '3',
        name: 'Sport Club do Recife',
        logoUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?text=SPT',
        categories: ['Sub-15'],
        positions: ['Fixo'],
        hasTryouts: true,
      ),
      ClubModel(
        id: '4',
        name: 'Pato Futsal',
        logoUrl: 'https://via.placeholder.com/150/FFD700/000000?text=PATO',
        categories: ['Sub-17'],
        positions: ['Pivô'],
        hasTryouts: true,
      ),
      ClubModel(
        id: '5',
        name: 'Corinthians',
        logoUrl: 'https://via.placeholder.com/150/000000/FFFFFF?text=COR',
        categories: ['Sub-17'],
        positions: ['Ala'],
        hasTryouts: false,
      ),
      ClubModel(
        id: '6',
        name: 'Red Bull Brasil',
        logoUrl: 'https://via.placeholder.com/150/0000FF/FF0000?text=RBB',
        categories: ['Sub-17'],
        positions: ['Goleiro'],
        hasTryouts: false,
      ),
      ClubModel(
        id: '7',
        name: 'Goiás E.C.',
        logoUrl: 'https://via.placeholder.com/150/00FF00/FFFFFF?text=GOI',
        categories: ['Sub-15'],
        positions: ['Ala'],
        hasTryouts: false,
      ),
      ClubModel(
        id: '8',
        name: 'Bahia',
        logoUrl: 'https://via.placeholder.com/150/0000FF/FFFFFF?text=BAH',
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
        clubName: 'ABC F.C.',
        clubLogoUrl: 'https://via.placeholder.com/150/FFFF00/000000?text=ABC',
        category: 'Sub-15',
        position: 'Fixo',
        isOpen: true,
      ),
      TryoutModel(
        id: '2',
        clubId: '2',
        clubName: 'América F.C.',
        clubLogoUrl: 'https://via.placeholder.com/150/008000/FFFFFF?text=AME',
        category: 'Sub-15',
        position: 'Fixo',
        isOpen: true,
      ),
      TryoutModel(
        id: '3',
        clubId: '3',
        clubName: 'Sport Club do Recife',
        clubLogoUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?text=SPT',
        category: 'Sub-15',
        position: 'Fixo',
        isOpen: true,
      ),
      TryoutModel(
        id: '4',
        clubId: '4',
        clubName: 'Pato Futsal',
        clubLogoUrl: 'https://via.placeholder.com/150/FFD700/000000?text=PATO',
        category: 'Sub-17',
        position: 'Pivô',
        isOpen: true,
      ),
    ];
  }
} 