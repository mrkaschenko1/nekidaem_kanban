// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../blocs/authentication/auth_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../repositories/repository.dart';
import 'sign_in_form.dart';

class AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<Repository>(context);
    // mentioned here https://github.com/felangel/bloc/issues/587
    // ignore: close_sinks
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) =>
            LoginBloc(authBloc: authBloc, repository: repository),
        child: SignInForm(),
      ),
    );
  }
}
