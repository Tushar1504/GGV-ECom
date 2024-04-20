part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}
class SignUpRequiredEvent extends SignUpEvent{
  final int? userId;
  final String userName;
  final String password;

  SignUpRequiredEvent({this.userId, required this.userName, required this.password});
}