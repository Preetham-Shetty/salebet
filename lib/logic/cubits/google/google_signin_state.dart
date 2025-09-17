part of 'google_signin_cubit.dart';

abstract class GoogleSignInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GoogleSignInInitial extends GoogleSignInState {}

class GoogleSignInLoading extends GoogleSignInState {}

class GoogleSignInSuccess extends GoogleSignInState {
  final Widget nextScreen;
  GoogleSignInSuccess(this.nextScreen);

  @override
  List<Object?> get props => [nextScreen];
}

class GoogleSignInFailure extends GoogleSignInState {
  final String error;
  GoogleSignInFailure(this.error);

  @override
  List<Object?> get props => [error];
}
