import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit({required HomeRepository homeRepository}) 
      : _homeRepository = homeRepository,
        super(const HomeState());

  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final clubs = await _homeRepository.getClubs();
      final tryouts = await _homeRepository.getTryouts();

      emit(state.copyWith(
        status: HomeStatus.loaded,
        clubs: clubs,
        tryouts: tryouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
} 