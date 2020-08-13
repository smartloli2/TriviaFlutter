import 'package:tdd_learn/core/usecase/usecase.dart';
import 'package:tdd_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_learn/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import 'package:tdd_learn/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia      usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'Should get trivia from the repository',
    () async {
      
      // Arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));

      // Act
      // Since random number doesn't require any parameters, we pass in NoParams.
      final result = await usecase(NoParams());

      // Assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}