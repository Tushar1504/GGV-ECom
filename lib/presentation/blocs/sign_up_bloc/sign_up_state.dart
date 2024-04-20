part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState{
  final String? message;

  SignUpFailure(this.message);

}

class SignUpProgress extends SignUpState{}