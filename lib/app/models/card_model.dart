import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CardModel extends Equatable {
  final int id;
  final int row;
  final int seqNum;
  final String text;

  CardModel._({
    @required this.id,
    @required this.row,
    @required this.seqNum,
    @required this.text,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel._(
        id: json['id'] as int,
        row: int.parse(json['row']),
        seqNum: json['seq_num'] as int,
        text: json['text'] as String,
      );

  @override
  List<Object> get props => [id, row, seqNum, text];
}
