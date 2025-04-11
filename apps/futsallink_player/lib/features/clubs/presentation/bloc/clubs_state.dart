import 'package:equatable/equatable.dart';
import 'package:futsallink_player/features/home/domain/models/club_model.dart';

abstract class ClubsState extends Equatable {
  const ClubsState();
  
  @override
  List<Object?> get props => [];
}

class ClubsInitial extends ClubsState {}

class ClubsLoading extends ClubsState {}

class ClubsLoaded extends ClubsState {
  final List<ClubModel> allClubs;
  final List<ClubModel> filteredClubs;
  final String searchQuery;
  
  const ClubsLoaded({
    required this.allClubs,
    required this.filteredClubs,
    this.searchQuery = '',
  });
  
  ClubsLoaded copyWith({
    List<ClubModel>? allClubs,
    List<ClubModel>? filteredClubs,
    String? searchQuery,
  }) {
    return ClubsLoaded(
      allClubs: allClubs ?? this.allClubs,
      filteredClubs: filteredClubs ?? this.filteredClubs,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
  
  @override
  List<Object?> get props => [allClubs, filteredClubs, searchQuery];
}

class ClubsError extends ClubsState {
  final String message;
  
  const ClubsError(this.message);
  
  @override
  List<Object?> get props => [message];
} 