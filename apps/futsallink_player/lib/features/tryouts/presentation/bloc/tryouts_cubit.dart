import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/home/domain/repositories/home_repository.dart';
import 'tryouts_state.dart';

class TryoutsCubit extends Cubit<TryoutsState> {
  final HomeRepository _repository;
  
  TryoutsCubit(this._repository) : super(TryoutsInitial());
  
  Future<void> loadTryouts() async {
    emit(TryoutsLoading());
    
    try {
      final tryouts = await _repository.getTryouts();
      emit(TryoutsLoaded(
        allTryouts: tryouts,
        filteredTryouts: tryouts,
      ));
    } catch (e) {
      emit(TryoutsError('Erro ao carregar seletivas'));
    }
  }
  
  void searchTryouts(String query) {
    if (state is TryoutsLoaded) {
      final currentState = state as TryoutsLoaded;
      final allTryouts = currentState.allTryouts;
      
      if (query.isEmpty) {
        emit(currentState.copyWith(
          filteredTryouts: allTryouts,
          searchQuery: query,
        ));
        return;
      }
      
      final searchLower = query.toLowerCase();
      final filteredTryouts = allTryouts.where((tryout) {
        return tryout.clubName.toLowerCase().contains(searchLower) ||
               tryout.category.toLowerCase().contains(searchLower) ||
               tryout.position.toLowerCase().contains(searchLower);
      }).toList();
      
      emit(currentState.copyWith(
        filteredTryouts: filteredTryouts,
        searchQuery: query,
      ));
    }
  }
} 