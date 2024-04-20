import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../router/router_imports.gr.dart';

part 'logged_out_event.dart';
part 'logged_out_state.dart';

class LoggedOutBloc extends Bloc<LoggedOutEvent, LoggedOutState> {
  LoggedOutBloc() : super(LoggedOutInitial()) {
    on<UserRequestedLogout>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLogged');
      emit(LogoutSuccess());
      AutoRouter.of(event.context).replace(const LoginRoute());
    });
  }
}
