import 'package:equatable/equatable.dart';
import '../../domain/models/tryout_details_model.dart';

abstract class TryoutDetailsState extends Equatable {
  const TryoutDetailsState();
  
  @override
  List<Object?> get props => [];
}

class TryoutDetailsInitial extends TryoutDetailsState {}

class TryoutDetailsLoading extends TryoutDetailsState {}

class TryoutDetailsLoaded extends TryoutDetailsState {
  final TryoutDetailsModel tryoutDetails;
  
  const TryoutDetailsLoaded(this.tryoutDetails);
  
  @override
  List<Object?> get props => [tryoutDetails];
}

class TryoutDetailsError extends TryoutDetailsState {
  final String message;
  
  const TryoutDetailsError(this.message);
  
  @override
  List<Object?> get props => [message];
} 