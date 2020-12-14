import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nekidaem_kanban/app/models/card_model.dart';
import 'package:nekidaem_kanban/app/repositories/repository.dart';

part 'cards_event.dart';
part 'cards_state.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final Repository _repository;

  CardsBloc(Repository repository)
      : assert(repository != null),
        _repository = repository,
        super(CardsInitial());

  @override
  Stream<CardsState> mapEventToState(
    CardsEvent event,
  ) async* {
    if (event is CardsFetch) {
      yield CardsLoading();
      try {
        final cards = await _repository.getCards();
        print(cards[0].text);
        yield CardsFetched(cards: cards);
      } on SocketException {
        yield CardsFailure(message: 'Network Exception');
      } catch (e) {
        yield CardsFailure(message: e.toString() ?? 'Unknown error');
      }
    }
  }
}
