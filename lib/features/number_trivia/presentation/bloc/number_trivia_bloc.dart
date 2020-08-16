import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_learn/core/error/failure.dart';
import 'package:tdd_learn/core/usecase/usecase.dart';
import 'package:tdd_learn/core/util/input_converter.dart';
import 'package:tdd_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_learn/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_learn/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:meta/meta.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

// Const strings
const String SERVER_FAILURE_MESSAGE         = 'Server Failure';
const String CACHE_FAILURE_MESSAGE          = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE  =
    'Invalid Input - The number must be a positive integer or zero.';

// Bussiness logic component
class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  // Use cases
  final GetConcreteNumberTrivia getConcreteNumberTriviaUsecase;
  final GetRandomNumberTrivia   getRandomNumberTriviaUsecase;
  
  // Util
  final InputConverter          inputConverter;

  // Cons-r
  NumberTriviaBloc({
    // Changed the name of the constructor parameter (cannot use 'this.')
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
    // Asserts are how you can make sure that a passed in argument is not null.
    // We omit this elsewhere for the sake of brevity.
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTriviaUsecase = concrete,
        getRandomNumberTriviaUsecase = random, 
        super(Empty());


  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {

    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither?.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },

        (integer) async* {
          yield Loading();
          final failureOrTrivia = await getConcreteNumberTriviaUsecase(
            Params(number: integer),
          );
          yield failureOrTrivia.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (trivia) => Loaded(trivia: trivia),
          );
        },
      );
    }
    else if (event is GetTriviaForRandomNumber) {
      yield Empty();
      yield Loading();
      final failureOrTrivia = await getRandomNumberTriviaUsecase(
        NoParams(),
      );
      yield failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia),
      );
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  // Instead of a regular 'if (failure is ServerFailure)...'
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected Error';
  }
}
