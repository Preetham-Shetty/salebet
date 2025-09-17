import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:salesbets/logic/services/google/google_signin.dart';
import 'package:flutter/material.dart';
import 'package:salesbets/presentation/common/widgets/common/landing_page.dart';

part 'google_signin_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  final GoogleSigninService googleSigninProvider;

  GoogleSignInCubit(this.googleSigninProvider) : super(GoogleSignInInitial());

  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoading());
    try {
      await googleSigninProvider.googleLogIn();
      if (googleSigninProvider.isSignedIn()) {
        emit(GoogleSignInSuccess(LandingPage()));
      } else {
        emit(GoogleSignInFailure('Sign in failed'));
      }
    } catch (e) {
      emit(GoogleSignInFailure(e.toString()));
    }
  }
}
