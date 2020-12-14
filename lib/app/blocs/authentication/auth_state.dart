part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthInitial {}

class AuthNotAuthenticated extends AuthInitial {}

class AuthAuthenticated extends AuthInitial {
  final UserModel user;

  AuthAuthenticated({@required this.user});

  @override
  List<Object> get props => [user];
}
