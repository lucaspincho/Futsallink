import 'package:equatable/equatable.dart';
import '../../domain/models/club_model.dart';
import '../../domain/models/tryout_model.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<ClubModel> clubs;
  final List<TryoutModel> tryouts;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.clubs = const [],
    this.tryouts = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ClubModel>? clubs,
    List<TryoutModel>? tryouts,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      clubs: clubs ?? this.clubs,
      tryouts: tryouts ?? this.tryouts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, clubs, tryouts, errorMessage];
} 