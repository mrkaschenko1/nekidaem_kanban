part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final UserModel user;

  LoggedIn({@required this.user});

  @override
  List<Object> get props => [user];
}

class LoggedOut extends AuthEvent {}
