part of 'login_cubit.dart';

@immutable
sealed class LogiCubitState {}

final class LogiCubitInitial extends LogiCubitState {}

final class LoginCubitLoading extends LogiCubitState {}

final class LoginCubitFailure extends LogiCubitState {
  final String errMessage;

  LoginCubitFailure({required this.errMessage});
}

final class LoginCubitSuccess extends LogiCubitState {
  final Data dataInfo;

  LoginCubitSuccess({required this.dataInfo});
}

final class RegisterCubitInitial extends LogiCubitState {}

final class RegisterCubitLoading extends LogiCubitInitial {}

final class RegisterCubitNotWriteAll extends LogiCubitInitial {}

final class RegisterCubitFailuer extends LogiCubitState {
  final String errMessage;

  RegisterCubitFailuer({required this.errMessage});
}

final class RegisterCubitSuccess extends LogiCubitState {}
