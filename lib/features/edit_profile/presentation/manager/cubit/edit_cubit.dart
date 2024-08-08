import 'package:bloc/bloc.dart';
import 'package:educational_app/features/edit_profile/data/repo/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/user_model.dart';

part 'edit_state.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit(this.userReop) : super(EditInitial());
  static EditCubit get(context) => BlocProvider.of(context);
  final UserReop userReop;
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  User user = User();
  bool isRead = true;
  void startEdit() {
    isRead = false;
    print(isRead);
    emit(StartEdit());
  }

  void endEdit() {
    isRead = true;
    emit(EndEdit());

    print(isRead);
  }

  void canselEdit() {
    print("object");
    isRead = true;

    emit(EditInitial());
    print(state.toString());
  }

  Future<void> fetchUserInfo() async {
    emit(GetInfoLoading());
    var result = await userReop.getUserInfo();
    result.fold((failure) {
      emit(GetInfoFailure(errMessage: failure.errMassage));
    }, (fuser) {
      user = fuser;
      emit(GetInfoSuccess());
    });
  }

  Future<void> editUser(Map<String, dynamic> data) async {
    print(data);
    emit(EditLoading());
    var result = await userReop.editUser(data);
    result.fold((l) {
      emit(EditFailure(errMessage: l.errMassage));
    }, (r) {
      emit(EditSuccess());
    });
  }
}
