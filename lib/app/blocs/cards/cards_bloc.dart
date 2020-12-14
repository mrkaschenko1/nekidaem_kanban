// 🎯 Dart imports:
import 'dart:async';
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import '../../repositories/repository.dart';

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
        final rows = await _repository.getCardsInRows();
        yield CardsFetched(rows: rows);
      } on SocketException {
        yield CardsFailure(message: 'Network Exception');
      } catch (e) {
        yield CardsFailure(message: e.toString() ?? 'Unknown error');
      }
    }
  }
}
