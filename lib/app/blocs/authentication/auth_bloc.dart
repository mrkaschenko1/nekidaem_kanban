// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import '../../models/user_model.dart';
import '../../repositories/repository.dart';

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
        UserModel currentUser = await _repository.currentUser;
        if (currentUser != null) {
          currentUser = currentUser.copyWith(
            token: await _repository.refreshToken(currentUser.token),
          );
          yield AuthAuthenticated(user: currentUser);
        } else {
          yield AuthNotAuthenticated();
        }
      } on Exception {
        // if we can't refresh token then logout
        await _repository.logout();
        yield AuthNotAuthenticated();
      }
    }
    if (event is LoggedIn) {
      yield AuthAuthenticated(user: event.user);
    }
    if (event is LoggedOut) {
      yield AuthLoading();
      await _repository.logout();
      yield AuthNotAuthenticated();
    }
  }
}
