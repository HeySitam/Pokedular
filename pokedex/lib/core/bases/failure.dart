import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  String? message;
  Failure({this.message});
}

// General Failures
class ServerFailure extends Failure{
  ServerFailure({super.message});

  @override
  List<Object?> get props => [message];
}