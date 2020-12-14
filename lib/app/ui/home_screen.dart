import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nekidaem_kanban/app/blocs/authentication/auth_bloc.dart';
import 'package:nekidaem_kanban/app/blocs/cards/cards_bloc.dart';
import 'package:nekidaem_kanban/app/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: BlocBuilder<CardsBloc, CardsState>(
        builder: (context, state) {
          if (state is CardsFetched) {
            return SafeArea(
              minimum: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: [
                          ...state.cards
                              .map((e) => Column(children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(e.text),
                                  ]))
                              .toList(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FlatButton(
                      child: Text('Logout'),
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state is CardsFailure) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  FlatButton(
                    child: Text('Try again'),
                    onPressed: () {
                      BlocProvider.of<CardsBloc>(context).add(CardsFetch());
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
