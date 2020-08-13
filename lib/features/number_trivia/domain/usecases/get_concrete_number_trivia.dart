import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:tdd_learn/core/error/failure.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:tdd_learn/core/usecase/usecase.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params>{
  final NumberTriviaRepository repository;

  // Constructor
  GetConcreteNumberTrivia(this.repository);

  // Exec for test
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

// Params for getConcreteNum()
class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];// : super([number]);
}