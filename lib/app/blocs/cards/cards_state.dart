part of 'cards_bloc.dart';

abstract class CardsState extends Equatable {
  const CardsState();

  @override
  List<Object> get props => [];
}

class CardsInitial extends CardsState {}

class CardsLoading extends CardsState {}

class CardsFetched extends CardsState {
  final List<CardModel> cards;

  CardsFetched({@required this.cards});
}

class CardsFailure extends CardsState {
  final String message;

  CardsFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
