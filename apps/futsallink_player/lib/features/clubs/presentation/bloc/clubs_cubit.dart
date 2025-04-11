import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/home/domain/repositories/home_repository.dart';
import 'clubs_state.dart';

class ClubsCubit extends Cubit<ClubsState> {
  final HomeRepository _repository;
  
  ClubsCubit(this._repository) : super(ClubsInitial());
  
  Future<void> loadClubs() async {
    emit(ClubsLoading());
    
    try {
      final clubs = await _repository.getClubs();
      emit(ClubsLoaded(
        allClubs: clubs,
        filteredClubs: clubs,
      ));
    } catch (e) {
      emit(ClubsError('Erro ao carregar clubes'));
    }
  }
  
  void searchClubs(String query) {
    if (state is ClubsLoaded) {
      final currentState = state as ClubsLoaded;
      final allClubs = currentState.allClubs;
      
      if (query.isEmpty) {
        emit(currentState.copyWith(
          filteredClubs: allClubs,
          searchQuery: query,
        ));
        return;
      }
      
      final searchLower = query.toLowerCase();
      final filteredClubs = allClubs.where((club) {
        return club.name.toLowerCase().contains(searchLower);
      }).toList();
      
      emit(currentState.copyWith(
        filteredClubs: filteredClubs,
        searchQuery: query,
      ));
    }
  }
} 