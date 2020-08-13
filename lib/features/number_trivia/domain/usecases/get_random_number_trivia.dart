import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  // Store the repos
  final NumberTriviaRepository repository;

  // Constructor gets the repos
  GetRandomNumberTrivia(this.repository);

  // Call method calls the corresponding method from the repository
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}