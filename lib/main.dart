// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 🌎 Project imports:
import 'package:nekidaem_kanban/app/blocs/authentication/auth_bloc.dart';
import 'package:nekidaem_kanban/app/blocs/cards/cards_bloc.dart';
import 'package:nekidaem_kanban/app/repositories/api.dart';
import 'app/repositories/repository.dart';
import 'app/ui/home_screen.dart';
import 'app/ui/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => Repository(
          apiEndponts: API.getInstance(),
          secureStorage: FlutterSecureStorage()),
      child: BlocProvider<AuthBloc>(
        create: (context) {
          final repository = RepositoryProvider.of<Repository>(context);
          return AuthBloc(repository)..add(AppLoaded());
        },
        child: MaterialApp(
          title: 'NeKidaem',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) {
              if (state is AuthAuthenticated) {
                return BlocProvider(
                  create: (context) =>
                      CardsBloc(RepositoryProvider.of<Repository>(context))
                        ..add(CardsFetch()),
                  child: HomeScreen(
                    user: state.user,
                  ),
                );
              }
              return LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
