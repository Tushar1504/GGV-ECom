part of 'logged_out_bloc.dart';

@immutable
sealed class LoggedOutState {}

final class LoggedOutInitial extends LoggedOutState {}

class LogoutSuccess extends LoggedOutState {}

class LogoutFailure extends LoggedOutState {
  final String error;
  LogoutFailure(this.error);
}