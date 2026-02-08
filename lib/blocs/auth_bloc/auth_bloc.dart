import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoadingState());

        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                email: event.email,
                password: event.password,
              );
          emit(LoginSuccessState());
        } on FirebaseAuthException catch (e) {
          print('e.code:  ${e.message}');
          if (e.code == 'user-not-found') {
            emit(LoginFailureState(errorMessage: 'user-not-found'));
          } else if (e.code == 'wrong-password') {
            emit(LoginFailureState(errorMessage: 'wrong-password'));
          } else {
            emit(
              LoginFailureState(errorMessage: 'check your passowrd or email'),
            );
          }
        } catch (e) {
          emit(LoginFailureState(errorMessage: 'something went wrong'));
        }
      }
    });
  }


}
