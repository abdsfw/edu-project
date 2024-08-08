part of 'edit_cubit.dart';

@immutable
sealed class EditState {}

final class EditInitial extends EditState {}

final class EditLoading extends EditState {}

final class EditSuccess extends EditState {}

final class EditFailure extends EditState {
  final String errMessage;

  EditFailure({required this.errMessage});
}

final class StartEdit extends EditState {}

final class EndEdit extends EditState {}

final class GetInfoLoading extends EditState {}

final class GetInfoFailure extends EditState {
  final String errMessage;

  GetInfoFailure({required this.errMessage});
}

final class GetInfoSuccess extends EditState {}
