// Em packages/futsallink_core/lib/domain/entities/auth_credential.dart

import 'package:equatable/equatable.dart';

class AuthCredential extends Equatable {
  final String? uid;
  final String? email;
  final String? phoneNumber;
  final String? verificationId;
  final String? verificationCode;
  final bool isVerified;
  final AuthMethod authMethod;
  final DateTime? codeExpiration;
  final VerificationStatus verificationStatus;

  const AuthCredential({
    this.uid,
    this.email,
    this.phoneNumber,
    this.verificationId,
    this.verificationCode,
    this.isVerified = false,
    this.authMethod = AuthMethod.email,
    this.codeExpiration,
    this.verificationStatus = VerificationStatus.notStarted,
  });

  @override
  List<Object?> get props => [
    uid, 
    email, 
    phoneNumber, 
    verificationId, 
    verificationCode, 
    isVerified, 
    authMethod,
    codeExpiration,
    verificationStatus,
  ];

  // Método para criar uma cópia com algumas propriedades alteradas
  AuthCredential copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? verificationId,
    String? verificationCode,
    bool? isVerified,
    AuthMethod? authMethod,
    DateTime? codeExpiration,
    VerificationStatus? verificationStatus,
  }) {
    return AuthCredential(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationId: verificationId ?? this.verificationId,
      verificationCode: verificationCode ?? this.verificationCode,
      isVerified: isVerified ?? this.isVerified,
      authMethod: authMethod ?? this.authMethod,
      codeExpiration: codeExpiration ?? this.codeExpiration,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }
  
  bool get isCodeExpired {
    if (codeExpiration == null) return false;
    return DateTime.now().isAfter(codeExpiration!);
  }
}

enum AuthMethod {
  email,
  phone,
}

enum VerificationStatus {
  notStarted,
  pendingCodeVerification, // Código enviado, aguardando verificação
  codeVerified,            // Código verificado com sucesso
  pendingPasswordCreation, // Aguardando criação de senha
  completed,               // Processo completo
  failed,                  // Falha no processo
}