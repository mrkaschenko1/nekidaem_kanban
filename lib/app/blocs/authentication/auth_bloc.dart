import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:nekidaem_kanban/app/models/user_model.dart';
import 'package:nekidaem_kanban/app/repositories/repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Repository _repository;

  AuthBloc(Repository repository)
      : assert(repository != null),
        _repository = repository,
        super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppLoaded) {
      yield AuthLoading();
      try {
        final currentUser = await _repository.currentUser;

        if (currentUser != null) {
          yield AuthAuthenticated(user: currentUser);
        } else {
          yield AuthNotAuthenticated();
        }
      } on Response catch (e) {
        yield AuthFailure(message: e.reasonPhrase);
      } catch (e) {
        yield AuthFailure(message: e.message ?? 'Unknown error');
      }
    }
    if (event is LoggedIn) {
      yield AuthAuthenticated(user: event.user);
    }
    if (event is LoggedOut) {
      await _repository.logout();
      yield AuthNotAuthenticated();
    }
  }
}
