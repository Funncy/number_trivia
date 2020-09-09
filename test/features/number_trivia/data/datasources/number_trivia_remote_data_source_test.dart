import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpmockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong!', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/$tNumber',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpmockHttpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform a GET request on a URL with *random* endpoint with application/json header',
        () {
      //arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      // assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'},
      ));
    });
    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpmockHttpClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
