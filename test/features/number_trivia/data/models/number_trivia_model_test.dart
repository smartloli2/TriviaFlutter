import 'dart:convert';

import 'package:tdd_learn/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_learn/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';



void main() {
  // Create NumberTriviaModel for tests
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  // Subclass test
  test(
    'Should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  // Tests for fromJSON method
  group('FromJson', () {
    test(
      'Should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            // Read file to String and then decode to jsonMap
            json.decode(fixture('trivia.json'));
        //print(jsonMap['text']);
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'Should return a valid model when the JSON number is regarded as a double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  // Tests for toJSON method
  group('ToJson', () {
  test(
    'Should return a JSON map containing the proper data',
    () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectedJsonMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedJsonMap);
    },
  );


});

  
}