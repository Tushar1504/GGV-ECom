import 'package:bloc/bloc.dart';
import 'package:ggv_ecom/data/models/user_model.dart';
import 'package:meta/meta.dart';

import '../../../data/data_sources/remote/sqlite.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final DataBaseHelper _dataBaseHelper;
  SignUpBloc(DataBaseHelper dataBaseHelper)
      : _dataBaseHelper = dataBaseHelper,
        super(SignUpInitial()) {
    on<SignUpRequiredEvent>((event, emit) async {
      emit(SignUpProgress());
      try {
        final isSignInSuccessFull = await _dataBaseHelper.signup(Users(
          userName: event.userName,
          password: event.password,
        ));
        if (isSignInSuccessFull > 0) {
          emit(SignUpSuccess());
        }
      } catch (error) {
        emit(SignUpFailure("Invalid User Credential!!!"));
      }
    });
  }
}
