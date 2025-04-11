import 'package:equatable/equatable.dart';
import '../../domain/models/club_details_model.dart';

abstract class ClubDetailsState extends Equatable {
  const ClubDetailsState();
  
  @override
  List<Object?> get props => [];
}

class ClubDetailsInitial extends ClubDetailsState {}

class ClubDetailsLoading extends ClubDetailsState {}

class ClubDetailsLoaded extends ClubDetailsState {
  final ClubDetailsModel clubDetails;
  
  const ClubDetailsLoaded(this.clubDetails);
  
  @override
  List<Object?> get props => [clubDetails];
}

class ClubDetailsError extends ClubDetailsState {
  final String message;
  
  const ClubDetailsError(this.message);
  
  @override
  List<Object?> get props => [message];
} 