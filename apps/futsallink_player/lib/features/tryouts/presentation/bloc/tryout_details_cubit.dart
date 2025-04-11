import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/tryout_repository.dart';
import 'tryout_details_state.dart';

class TryoutDetailsCubit extends Cubit<TryoutDetailsState> {
  final TryoutRepository _repository;
  
  TryoutDetailsCubit(this._repository) : super(TryoutDetailsInitial());
  
  Future<void> loadTryoutDetails(String tryoutId) async {
    emit(TryoutDetailsLoading());
    
    try {
      final tryoutDetails = await _repository.getTryoutDetails(tryoutId);
      emit(TryoutDetailsLoaded(tryoutDetails));
    } catch (e) {
      emit(TryoutDetailsError('Erro ao carregar detalhes da seletiva'));
    }
  }
} 