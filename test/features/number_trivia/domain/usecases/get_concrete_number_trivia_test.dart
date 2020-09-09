import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_tirivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  //test 코드 시작
  final tNumber = 1;
  final tNumberTirivia = NumberTrivia(text: "test", number: 1);

  test('should get tirivia for the number from the repository', () async {
    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTirivia));
    // act , 아직 구현되지 않음 함수
    final result = await usecase(Params(number: tNumber));
    // assert
    expect(result, Right(tNumberTirivia));
    // Repository에서 함수가 호출되었는지 확인
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    // 위의 방법만 호출하고 더 이상 호출하면 안된다.
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
