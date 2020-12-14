// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/card_model.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;

  const CardWidget({Key key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            'ID: ${card.id}',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            card.text,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
