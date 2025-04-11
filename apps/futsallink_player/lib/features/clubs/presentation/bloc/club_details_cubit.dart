import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/club_repository.dart';
import 'club_details_state.dart';

class ClubDetailsCubit extends Cubit<ClubDetailsState> {
  final ClubRepository _repository;
  
  ClubDetailsCubit(this._repository) : super(ClubDetailsInitial());
  
  Future<void> loadClubDetails(String clubId) async {
    emit(ClubDetailsLoading());
    
    try {
      final clubDetails = await _repository.getClubDetails(clubId);
      emit(ClubDetailsLoaded(clubDetails));
    } catch (e) {
      emit(ClubDetailsError('Erro ao carregar detalhes do clube'));
    }
  }
} 