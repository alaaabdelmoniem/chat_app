import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snak_bar.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/widgets/Password_text_field.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_form_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  String? email, password;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
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
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        Navigator.pushNamed(
                          context,
                          ChatScreen.id,
                          arguments: email,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnakBar(context, 'user not found');
                        } else if (e.code == 'wrong-password') {
                          showSnakBar(context, 'wrong-password');
                        }
                      } catch (e) {
                        showSnakBar(context, 'there was en error');
                      }
                      isLoading = false;
                      setState(() {});
                    }
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
    );
  }

  Future<void> loginUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
