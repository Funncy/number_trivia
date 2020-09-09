import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // 하위 클래스에 properties가 있으면 생성자를 통해
  // Equatable의 비교가 동작한다.
  List properties;
  Failure([properties = const <dynamic>[]]);

  @override
  List<Object> get props => properties;
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
