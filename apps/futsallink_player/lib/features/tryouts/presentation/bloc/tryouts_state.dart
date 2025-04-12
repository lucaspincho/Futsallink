import 'package:equatable/equatable.dart';
import 'package:futsallink_player/features/home/domain/models/tryout_model.dart';

abstract class TryoutsState extends Equatable {
  const TryoutsState();
  
  @override
  List<Object?> get props => [];
}

class TryoutsInitial extends TryoutsState {}

class TryoutsLoading extends TryoutsState {}

class TryoutsLoaded extends TryoutsState {
  final List<TryoutModel> allTryouts;
  final List<TryoutModel> filteredTryouts;
  final String searchQuery;
  
  const TryoutsLoaded({
    required this.allTryouts,
    required this.filteredTryouts,
    this.searchQuery = '',
  });
  
  TryoutsLoaded copyWith({
    List<TryoutModel>? allTryouts,
    List<TryoutModel>? filteredTryouts,
    String? searchQuery,
  }) {
    return TryoutsLoaded(
      allTryouts: allTryouts ?? this.allTryouts,
      filteredTryouts: filteredTryouts ?? this.filteredTryouts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
  
  @override
  List<Object?> get props => [allTryouts, filteredTryouts, searchQuery];
}

class TryoutsError extends TryoutsState {
  final String message;
  
  const TryoutsError(this.message);
  
  @override
  List<Object?> get props => [message];
} 