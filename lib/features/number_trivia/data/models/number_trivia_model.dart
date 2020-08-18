import 'package:meta/meta.dart';

import '../../domain/entities/number_trivia.dart';

// Model that extends NumberTrivia entity
class NumberTriviaModel extends NumberTrivia 
{
  // Constructor
  NumberTriviaModel({
    @required String text,
    @required int number,
  }) : super(
          text: text,
          number: number,
        );
  
  // FromJSON 
  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  // ToJSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }


}