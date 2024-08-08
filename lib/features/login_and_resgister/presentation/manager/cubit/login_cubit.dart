import 'package:bloc/bloc.dart';
import 'package:educational_app/constants.dart';
import 'package:educational_app/core/cache/cashe_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/data_model.dart';
import '../../../data/model/data_user_model.dart';
import '../../../data/repo/login_repo.dart';

part 'login_state.dart';

class LogiCubitCubit extends Cubit<LogiCubitState> {
  LogiCubitCubit(this.loginrepo) : super(LogiCubitInitial());
  LoginRepo loginrepo;
  Data loginData = Data();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? autoFillUser = '';
  String autofillPassword = '';
  //! -------------------- RegisterVar -----------------------------
  TextEditingController nameRegisterController = TextEditingController();
  TextEditingController usernameRegisterController = TextEditingController();
  TextEditingController emailRegisterController = TextEditingController();
  TextEditingController passwordRegisterController = TextEditingController();
  TextEditingController confirmpasswordRegisterController =
      TextEditingController();
  String registermode = 'N/N';
//!-------------------------GetIt ---------------------------------
  static LogiCubitCubit get(context) => BlocProvider.of(context);

  //!-------------------------APIS---------------------------
  Future<void> login(Map<String, dynamic> data) async {
    emit(LoginCubitLoading());
    var result = await loginrepo.postlogin(data);
    result.fold((failure) {
      print(failure.errMassage);
      emit(LoginCubitFailure(errMessage: failure.errMassage));
    }, (loginInof) {
      CasheHelper.setData(key: Constants.kToken, value: loginInof.token);
      loginData = loginInof;

      emit(LoginCubitSuccess(dataInfo: loginInof));
    });
  }

  Future<void> userregister(Map<String, dynamic> data) async {
    print(data);

    emit(RegisterCubitLoading());
    var result = await loginrepo.postresgister(data);
    result.fold((failure) {
      print(failure.errMassage);
      emit(RegisterCubitFailuer(errMessage: failure.errMassage));
    }, (loginInof) {
      registermode = "Ok";

      emit(RegisterCubitSuccess());
    });
  }
}
