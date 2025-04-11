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
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tincidunt feugiat augue quis facilisis. Integer malesuada imperdiet tortor. Nullam congue placerat eros, non varius velit facilisis eu. Aenean nisl dolor, porta eu urna sed, semper imperdiet lorem. Sed vitae mi vitae lectus congue venenatis. Nunc convallis, magna ut laoreet mattis, ante tortor lobortis ante, in efficitur sapien mauris non risus. Aenean ac quam eu velit tincidunt malesuada viverra id leo. Cras porttitor turpis non orci placerat, et pharetra justo volutpat. Curabitur turpis odio, ultricies eget efficitur sit amet, blandit a quam.

      Morbi lectus urna, vulputate in viverra ac, vehicula non neque. Suspendisse potenti. Maecenas porttitor venenatis turpis, sed imperdiet mi interdum in. Duis consectetur purus turpis, nec blandit nisl ullamcorper sed. Aliquam cursus nunc non nisi congue rhoncus. Quisque hendrerit tempus faucibus. Etiam in mollis magna, eget imperdiet felis. Duis euismod neque et risus varius finibus.
      ''',
      isOpen: true,
    );
  }
} 