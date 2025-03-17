// Em apps/futsallink_player/lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/futsallink_core.dart';

// Extensão para manipular as mensagens de erro
extension FailureMessage on Failure {
  String get message {
    if (this is ServerFailure) return (this as ServerFailure).message;
    if (this is CacheFailure) return (this as CacheFailure).message;
    if (this is AuthFailure) return (this as AuthFailure).message;
    if (this is ValidationFailure) return (this as ValidationFailure).message;
    return 'Erro desconhecido';
  }
}

// Events - adicionando novos eventos para o fluxo de autenticação
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Eventos para escolha do método de autenticação
class ChooseAuthMethodEvent extends AuthEvent {
  final AuthMethod authMethod;
  
  const ChooseAuthMethodEvent({required this.authMethod});
  
  @override
  List<Object?> get props => [authMethod];
}

// Eventos para verificação de email
class InitiateEmailVerificationEvent extends AuthEvent {
  final String email;
  
  const InitiateEmailVerificationEvent({required this.email});
  
  @override
  List<Object?> get props => [email];
}

class CheckEmailVerificationEvent extends AuthEvent {
  final String email;
  
  const CheckEmailVerificationEvent({required this.email});
  
  @override
  List<Object?> get props => [email];
}

// Eventos para verificação de telefone
class InitiatePhoneVerificationEvent extends AuthEvent {
  final String phoneNumber;
  
  const InitiatePhoneVerificationEvent({required this.phoneNumber});
  
  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyPhoneCodeEvent extends AuthEvent {
  final String verificationId;
  final String code;

  const VerifyPhoneCodeEvent({required this.verificationId, required this.code});

  @override
  List<Object?> get props => [verificationId, code];
}

// Evento para completar o cadastro após verificação
class CompleteSignUpEvent extends AuthEvent {
  final AuthCredential credential;
  final String password;
  final String? name;
  
  const CompleteSignUpEvent({
    required this.credential,
    required this.password,
    this.name,
  });
  
  @override
  List<Object?> get props => [credential, password, name];
}

class LoginWithEmailPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailPasswordEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginWithPhoneEvent extends AuthEvent {
  final String phoneNumber;

  const LoginWithPhoneEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  const RegisterEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class UpdatePasswordEvent extends AuthEvent {
  final String newPassword;

  const UpdatePasswordEvent({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class LogoutEvent extends AuthEvent {}

// States - adicionando novos estados para o fluxo de autenticação
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  const AuthenticatedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class UnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

// Novo estado para a escolha do método de autenticação
class AuthMethodSelectionState extends AuthState {
  final AuthMethod? selectedMethod;
  
  const AuthMethodSelectionState({this.selectedMethod});
  
  @override
  List<Object?> get props => [selectedMethod];
}

// Novos estados para verificação de email
class EmailVerificationSentState extends AuthState {
  final String email;
  
  const EmailVerificationSentState({required this.email});
  
  @override
  List<Object?> get props => [email];
}

class EmailVerificationCompletedState extends AuthState {
  final AuthCredential credential;
  
  const EmailVerificationCompletedState({required this.credential});
  
  @override
  List<Object?> get props => [credential];
}

// Estados para verificação de telefone
class PhoneVerificationSentState extends AuthState {
  final AuthCredential credential;
  final String verificationId;

  const PhoneVerificationSentState({
    required this.credential,
    required this.verificationId,
  });

  @override
  List<Object?> get props => [credential, verificationId];
}

class PhoneVerificationCompletedState extends AuthState {
  final AuthCredential credential;

  const PhoneVerificationCompletedState({required this.credential});

  @override
  List<Object?> get props => [credential];
}

// Estado para definição de senha
class PasswordCreationState extends AuthState {
  final AuthCredential credential;
  
  const PasswordCreationState({required this.credential});
  
  @override
  List<Object?> get props => [credential];
}

class PasswordResetSentState extends AuthState {}

class PasswordUpdatedState extends AuthState {}

class RegistrationCompletedState extends AuthState {
  final User user;
  
  const RegistrationCompletedState({required this.user});
  
  @override
  List<Object?> get props => [user];
}

// Bloc - refatorado para usar casos de uso e adicionar novos métodos
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Casos de uso injetados
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final InitiateEmailVerificationUseCase _initiateEmailVerificationUseCase;
  final InitiatePhoneVerificationUseCase _initiatePhoneVerificationUseCase;
  final VerifyEmailCodeUseCase _verifyEmailCodeUseCase;
  final VerifyPhoneCodeUseCase _verifyPhoneCodeUseCase;
  final CompleteSignUpUseCase _completeSignUpUseCase;
  final CheckEmailRegistrationUseCase _checkEmailRegistrationUseCase;
  final CheckPhoneRegistrationUseCase _checkPhoneRegistrationUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthBloc({
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required InitiateEmailVerificationUseCase initiateEmailVerificationUseCase,
    required InitiatePhoneVerificationUseCase initiatePhoneVerificationUseCase,
    required VerifyEmailCodeUseCase verifyEmailCodeUseCase,
    required VerifyPhoneCodeUseCase verifyPhoneCodeUseCase,
    required CompleteSignUpUseCase completeSignUpUseCase,
    required CheckEmailRegistrationUseCase checkEmailRegistrationUseCase,
    required CheckPhoneRegistrationUseCase checkPhoneRegistrationUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _signInWithEmailUseCase = signInWithEmailUseCase,
        _signUpWithEmailUseCase = signUpWithEmailUseCase,
        _initiateEmailVerificationUseCase = initiateEmailVerificationUseCase,
        _initiatePhoneVerificationUseCase = initiatePhoneVerificationUseCase,
        _verifyEmailCodeUseCase = verifyEmailCodeUseCase,
        _verifyPhoneCodeUseCase = verifyPhoneCodeUseCase,
        _completeSignUpUseCase = completeSignUpUseCase,
        _checkEmailRegistrationUseCase = checkEmailRegistrationUseCase,
        _checkPhoneRegistrationUseCase = checkPhoneRegistrationUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _updatePasswordUseCase = updatePasswordUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _signOutUseCase = signOutUseCase,
        super(AuthInitial()) {
    
    // Registrando handlers para eventos
    on<ChooseAuthMethodEvent>(_onChooseAuthMethod);
    on<InitiateEmailVerificationEvent>(_onInitiateEmailVerification);
    on<CheckEmailVerificationEvent>(_onCheckEmailVerification);
    on<InitiatePhoneVerificationEvent>(_onInitiatePhoneVerification);
    on<VerifyPhoneCodeEvent>(_onVerifyPhoneCode);
    on<CompleteSignUpEvent>(_onCompleteSignUp);
    on<LoginWithEmailPasswordEvent>(_onLoginWithEmailPassword);
    on<LoginWithPhoneEvent>(_onLoginWithPhone);
    on<RegisterEvent>(_onRegister);
    on<ResetPasswordEvent>(_onResetPassword);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<LogoutEvent>(_onLogout);
  }

  // Método para escolher método de autenticação
  Future<void> _onChooseAuthMethod(
    ChooseAuthMethodEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthMethodSelectionState(selectedMethod: event.authMethod));
  }
  
  // Método para iniciar verificação de email
  Future<void> _onInitiateEmailVerification(
    InitiateEmailVerificationEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _initiateEmailVerificationUseCase(event.email);
    
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (credential) => emit(EmailVerificationSentState(email: event.email)),
    );
  }
  
  // Método para verificar se o email foi verificado
  Future<void> _onCheckEmailVerification(
    CheckEmailVerificationEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _verifyEmailCodeUseCase(event.email, '');
    
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (credential) => emit(
        credential.isVerified
          ? PasswordCreationState(credential: credential)
          : AuthErrorState(message: 'Email ainda não verificado. Verifique sua caixa de entrada.'),
      ),
    );
  }
  
  // Método para iniciar verificação de telefone
  Future<void> _onInitiatePhoneVerification(
    InitiatePhoneVerificationEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _initiatePhoneVerificationUseCase(event.phoneNumber);
    
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (credential) => emit(PhoneVerificationSentState(
        credential: credential,
        verificationId: credential.verificationId ?? '',
      )),
    );
  }

  // Método para verificar código de telefone
  Future<void> _onVerifyPhoneCode(
    VerifyPhoneCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _verifyPhoneCodeUseCase(event.verificationId, event.code);

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (credential) {
        if (credential.uid != null && credential.verificationStatus == VerificationStatus.completed) {
          // Usuário já existente, buscar perfil
          _getCurrentUserUseCase().then(
            (userResult) => userResult.fold(
              (failure) => emit(AuthErrorState(message: failure.message)),
              (user) => user != null 
                  ? emit(AuthenticatedState(user: user))
                  : emit(const AuthErrorState(message: 'Usuário não encontrado')),
            ),
          );
        } else {
          // Usuário novo verificado, precisa definir senha
          emit(PasswordCreationState(credential: credential));
        }
      },
    );
  }
  
  // Método para completar o cadastro após verificação
  Future<void> _onCompleteSignUp(
    CompleteSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _completeSignUpUseCase(
      event.credential,
      event.password,
      name: event.name,
    );
    
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(RegistrationCompletedState(user: user)),
    );
  }

  Future<void> _onLoginWithEmailPassword(
    LoginWithEmailPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Usando o caso de uso que já contém a validação internamente
    final result = await _signInWithEmailUseCase(event.email, event.password);

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthenticatedState(user: user)),
    );
  }

  Future<void> _onLoginWithPhone(
    LoginWithPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _initiatePhoneVerificationUseCase(event.phoneNumber);
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (credential) => emit(PhoneVerificationSentState(
        credential: credential,
        verificationId: credential.verificationId ?? '',
      )),
    );
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _signUpWithEmailUseCase(event.email, event.password, '');

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthenticatedState(user: user)),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _resetPasswordUseCase(event.email);

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) => emit(PasswordResetSentState()),
    );
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _updatePasswordUseCase(event.newPassword);

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) => emit(PasswordUpdatedState()),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _signOutUseCase();

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) => emit(UnauthenticatedState()),
    );
  }
}