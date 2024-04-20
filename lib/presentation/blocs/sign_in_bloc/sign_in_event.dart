part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent {}

class SignInRequiredEvent extends SignInEvent{
  final int? userId;
  final String userName;
  final String password;
  final bool rememberMe;

  SignInRequiredEvent({this.userId, required this.userName, required this.password, this.rememberMe = false});
}