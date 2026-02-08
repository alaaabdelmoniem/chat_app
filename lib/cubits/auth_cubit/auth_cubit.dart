import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      print('e.code:  ${e.message}');
      if (e.code == 'user-not-found') {
        emit(LoginFailureState(errorMessage: 'user-not-found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailureState(errorMessage: 'wrong-password'));
      } else {
        emit(LoginFailureState(errorMessage: 'check your passowrd or email'));
      }
    } catch (e) {
      emit(LoginFailureState(errorMessage: 'something went wrong'));
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    emit(RegisterLoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailureState(errorMessage: 'weak-password'));
      } else if (e.code == 'email-already-in-use') {
        emit(
          RegisterFailureState(errorMessage: 'email already in use, try again'),
        );
      }
    } catch (e) {
      emit(RegisterFailureState(errorMessage: 'something went wrong'));
    }
  }


}
