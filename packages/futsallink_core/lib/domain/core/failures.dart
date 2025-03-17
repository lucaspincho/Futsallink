// lib/domain/core/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
  
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String message;
  
  const ServerFailure({this.message = 'Erro no servidor'});
  
  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  final String message;
  
  const CacheFailure({this.message = 'Erro de cache'});
  
  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  final String message;
  
  const AuthFailure({this.message = 'Erro de autenticação'});
  
  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;
  
  const ValidationFailure({this.message = 'Dados inválidos'});
  
  @override
  List<Object?> get props => [message];
}