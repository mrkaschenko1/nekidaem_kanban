// 🎯 Dart imports:
import 'dart:async';
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import '../../exceptions/auth_exception.dart';
import '../../repositories/repository.dart';
import '../authentication/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _authBloc;
  final Repository _repository;

  LoginBloc({@required AuthBloc authBloc, @required Repository repository})
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
          yield LoginInitial();
        } else {
          throw Exception();
        }
      } on AuthException catch (e) {
        yield LoginFailure(message: e.message);
      } on SocketException {
        yield LoginFailure(message: 'Network error');
      } catch (e) {
        yield LoginFailure(message: e.message ?? 'Unknown Error');
        print(e);
      }
    }
  }
}
