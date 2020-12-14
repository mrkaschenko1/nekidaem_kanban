// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'card_widget.dart';

class CardListView extends StatelessWidget {
  final Map<String, dynamic> row;
  const CardListView({
    Key key,
    this.row,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Center(
        child: (row['cards'].isNotEmpty)
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: [
                        ...row['cards']
                            .map(
                              (card) => CardWidget(card: card),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ],
              )
            : Text('No cards in this row'),
      ),
    );
  }
}
