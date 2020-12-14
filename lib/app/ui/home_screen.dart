// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../blocs/authentication/auth_bloc.dart';
import '../blocs/cards/cards_bloc.dart';
import '../models/user_model.dart';
import '../repositories/card_row.dart';
import 'card_list_view.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(initialIndex: 0, vsync: this, length: 4);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(CardRow.values);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () =>
                BlocProvider.of<AuthBloc>(context).add(LoggedOut()),
          )
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: [
            ...CardRow.values
                .map((e) => Tab(
                      child: Text(
                        e.displayTitle,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ))
                .toList()
          ],
        ),
      ),
      body: BlocBuilder<CardsBloc, CardsState>(
        builder: (context, state) {
          if (state is CardsFetched) {
            return TabBarView(controller: _controller, children: [
              ...state.rows
                  .map(
                    (row) => CardListView(
                      row: row,
                    ),
                  )
                  .toList(),
            ]);
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
