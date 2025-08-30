import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snak_bar.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/Password_text_field.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_form_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key,});
  static String id = 'SignUpScreen';


  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  String? email;
  String? password;
  bool isLoading = false;

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
                      'Sign Up',

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
                  title: 'Sign Up',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await registerUser();
                        Navigator.pushNamed(context, ChatScreen.id, arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnakBar(context, 'weak-password');
                        } else if (e.code == 'email-already-in-use') {
                          showSnakBar(
                            context,
                            'The account already exists for that email.',
                          );
                        }
                      } catch (e) {
                        showSnakBar(context, 'there was an error');
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
                      'you have already an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      child: Text(
                        'Login',
                        style: TextStyle(color: Color(0xffC7EDE6)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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

  Future<void> registerUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email:email!,
          password:password!,
        );
  }
}
