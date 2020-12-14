// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nekidaem_kanban/app_localizations.dart';

// 🌎 Project imports:
import '../../blocs/login/login_bloc.dart';

class SignInForm extends StatefulWidget {
  static const int PASSWORD_MIN = 8;
  static const int PASSWORD_MAX = 50;
  static const int USERNAME_MIN = 4;
  static const int USERNAME_MAX = 150;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // mentioned here https://github.com/felangel/bloc/issues/587
    // ignore: close_sinks
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      FocusScope.of(context).unfocus();
      final isValid = _key.currentState.validate();
      if (isValid) {
        _key.currentState.save();
        _loginBloc.add(LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ));
      }
    }

    String _fieldValidator(String value, int minValue, int maxValue) {
      if (value == '') {
        return AppLocalizations.of(context).translate("required");
      }
      if (value.length < minValue) {
        return AppLocalizations.of(context)
            .translate("minimum_length")
            .toString()
            .replaceFirst('@', minValue.toString());
      } else if (value.length > maxValue) {
        return AppLocalizations.of(context)
            .translate("maximum_length")
            .toString()
            .replaceFirst('@', maxValue.toString());
      }
      return null;
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.message);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate("username"),
                      filled: true,
                      isDense: true,
                    ),
                    controller: _usernameController,
                    autocorrect: false,
                    validator: (value) => _fieldValidator(
                      value,
                      SignInForm.USERNAME_MIN,
                      SignInForm.USERNAME_MAX,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate("password"),
                      filled: true,
                      isDense: true,
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) => _fieldValidator(
                      value,
                      SignInForm.PASSWORD_MIN,
                      SignInForm.PASSWORD_MAX,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0)),
                    child:
                        Text(AppLocalizations.of(context).translate("login")),
                    onPressed:
                        state is LoginLoading ? () {} : _onLoginButtonPressed,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError(String error) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        error,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}
