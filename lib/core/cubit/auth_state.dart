abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class StopLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class LogoutState extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class ChangeRole extends AuthState {}
