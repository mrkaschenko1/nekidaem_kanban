// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nekidaem_kanban/app_localizations.dart';

// 🌎 Project imports:
import 'app/blocs/authentication/auth_bloc.dart';
import 'app/blocs/cards/cards_bloc.dart';
import 'app/repositories/api.dart';
import 'app/repositories/repository.dart';
import 'app/ui/screens/home_screen.dart';
import 'app/ui/screens/login_screen.dart';

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
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''),
            const Locale('ru', ''),
          ],
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
