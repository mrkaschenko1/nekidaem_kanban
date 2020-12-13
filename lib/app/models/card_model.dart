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
      id: int.tryParse(json['id']),
      row: int.tryParse(json['row']),
      seqNum: int.tryParse(json['seq_num']),
      text: json['text']);

  @override
  List<Object> get props => [id, row, seqNum, text];
}
