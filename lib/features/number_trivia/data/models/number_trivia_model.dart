import 'package:number_trivia/features/number_trivia/domain/entities/number_tirivia.dart';
import 'package:meta/meta.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    @required String text,
    @required int number,
  }) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
        number: (json['number'] as num).toInt(), text: json['text']);
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
