import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_learn/core/error/exception.dart';
import 'package:tdd_learn/core/error/failure.dart';
import 'package:tdd_learn/core/network/network_info.dart';
import 'package:tdd_learn/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_learn/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_learn/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_learn/features/number_trivia/domain/entities/number_trivia.dart';




// Mock the remote
class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

// Mock the local
class MockLocalDataSource extends Mock 
    implements NumberTriviaLocalDataSource {}

// Mock the netInfo
class MockNetworkInfo extends Mock 
    implements NetworkInfo {}

void main() {
  // Create objs
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  // Set up objs
  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('Device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  // Test body for getConcreteNumberTrivia()
  group('getConcreteNumberTrivia', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tNumber = 1;
    // Model
    final tNumberTriviaModel = 
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    // Entity
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('Should check if the device is online', () async{
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('Should return remote data when the call to remote data source is successful',
          () async {
            // arrange
            when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            expect(result, equals(Right(tNumberTrivia)));
          },
      );

      test('Should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
        },
      );

      test('Should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
        test(
          'Should return last locally cached data when the cached data is present',
          () async {
            // arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          'Should return CacheFailure when there is no cached data present',
          () async {
            // arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
    });
  });

  // Test body for getRandomNumberTrivia()
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('Should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'Should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'Should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
        },
      );

      test(
        'Should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'Should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'Should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}

