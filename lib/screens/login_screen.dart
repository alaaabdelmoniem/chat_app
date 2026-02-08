import 'package:chat_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app/constants.dart';

import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';

import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/widgets/Password_text_field.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_form_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snak_bar.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static String id = 'LoginScreen';
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginLoadingState) {
          isLoading = true;
        } else if (state is LoginSuccessState) {
          BlocProvider.of<ChatCubit>(context).getMessage();
          Navigator.pushNamed(context, ChatScreen.id, arguments: email);
          isLoading = false;
        } else if (state is LoginFailureState) {
          showSnakBar(context, state.errorMessage);
          isLoading = false;
        }
      },
      builder:
          (context, state) => ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              backgroundColor: kPrimaryColor,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      SizedBox(height: 75),
                      Image.asset(kLogo, height: 100),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Scolar Chat',
                            style: TextStyle(
                              fontSize: 33,
                              color: Colors.white,
                              fontFamily: 'Pacifico',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 75),
                      const Row(
                        children: [
                          Text(
                            'Login',

                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Email',
                        onChanged: (data) {
                          email = data;
                        },
                      ),

                      const SizedBox(height: 10),

                      PasswordTextField(
                        hintText: 'Password',
                        onChanged: (data) {
                          password = data;
                        },
                      ),
                      const SizedBox(height: 30),

                      CustomButton(
                        title: 'Login',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthBloc>(context).add(
                              LoginEvent(email: email!, password: password!),
                            );
                          }
                          print('email : $email and password is $password');
                        },
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text(
                            'don\'t have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: Color(0xffC7EDE6)),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, SignUpScreen.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Future<void> loginUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
