part of 'number_trivia_bloc.dart';

// Interface for states
abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
  
  @override
  List<Object> get props => [];
}

// Empty state
class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

// Loading state
class Loading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

// Loaded state
class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({@required this.trivia});

  @override
  List<Object> get props => [trivia];

}

// Error state
class Error extends NumberTriviaState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
