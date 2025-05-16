part of 'sign_cubit.dart';

@immutable
sealed class SignState {}

class SignInitial extends SignState {}

class SignLoading extends SignState {}

class SignSuccess extends SignState {}

class SignFailure extends SignState {
  final String error;

  SignFailure(this.error);
}

class SignPasswordVisibility extends SignState {}

class SignRefresh extends SignState {}
