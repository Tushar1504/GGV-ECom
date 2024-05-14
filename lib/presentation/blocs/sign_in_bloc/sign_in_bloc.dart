import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/user_model.dart';
import '../../../data/data_sources/remote/sqlite.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final DataBaseHelper _dataBaseHelper;
  SignInBloc({required DataBaseHelper dataBaseHelper})
      : _dataBaseHelper = dataBaseHelper,
        super(SignInInitial()) {
    on<SignInRequiredEvent>((event, emit) async {
      emit(SignInProgress());
      try {
        final isSignInSuccessFull = await _dataBaseHelper
            .login(Users(userName: event.userName, password: event.password));
        if (isSignInSuccessFull) {
          if(event.rememberMe){
            final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLogged', true);
          }
          emit(SignInSuccess());
        }
        else {
          emit(SignInFailure("Invalid User Credential!!!"));
        }
      } catch (error) {
        emit(SignInFailure("Invalid User Credential!!!"));
      }
    });
  }
}

