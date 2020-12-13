import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../../repositories/repository.dart';
import '../authentication/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _authBloc;
  final Repository _repository;

  LoginBloc(AuthBloc authBloc, Repository repository)
      : assert(authBloc != null),
        assert(repository != null),
        _authBloc = authBloc,
        _repository = repository,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final user = await _repository.tryLogin(
            username: event.username, password: event.password);
        if (user != null) {
          _authBloc.add(LoggedIn(user: user));
          yield LoginSuccess();
          yield LoginInitial();
        } else {
          yield LoginFailure(message: 'Unknown Error');
        }
      } on Response catch (e) {
        yield LoginFailure(message: e.reasonPhrase);
      } catch (e) {
        yield LoginFailure(message: e.message ?? 'Unknown Error');
      }
    }
  }
}
