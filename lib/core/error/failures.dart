import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.str);
  final String str;
  @override
  List<Object> get props => [str];
}

