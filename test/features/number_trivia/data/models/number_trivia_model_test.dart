import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_tirivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a subclass of NumberTirivia entity', () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the Json number is an integer',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test(
        'should return a valid model when the Json number is regarded as a double',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, isA<NumberTriviaModel>());
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      //arrange
      final result = tNumberTriviaModel.toJson();
      //assert
      final expectedMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
