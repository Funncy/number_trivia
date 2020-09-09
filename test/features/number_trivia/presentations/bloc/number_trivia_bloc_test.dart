import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_tirivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc numberTriviaBloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  tearDown(() {
    numberTriviaBloc?.close();
  });

  test('initialState should be Empty', () {
    // assert
    expect(numberTriviaBloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    // event가 입력할 문자
    final tNumberString = '1';
    // InputConverter로 부터 들어올 데이터
    final tNumberParsed = int.parse(tNumberString);
    // Test용 NumberTrivia
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      // whenListen(numberTriviaBloc, Stream.value(Empty()));e
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      // act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      // assert later
      final expected = [
        // Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc, emitsInOrder(expected));
    });

    test('should get data from the concrete use case', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // assert later
      final expected = [
        // Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(numberTriviaBloc, emitsInOrder(expected));
      // act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        // Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc, emitsInOrder(expected));
      // act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      numberTriviaBloc.close();
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        // Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc, emitsInOrder(expected));
      // act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    // Test용 NumberTrivia
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // assert later
      final expected = [
        // Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(numberTriviaBloc, emitsInOrder(expected));
      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        // Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc, emitsInOrder(expected));
      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        // Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc, emitsInOrder(expected));
      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });
  });
}
