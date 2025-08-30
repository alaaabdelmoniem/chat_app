import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.onChanged,
    required this.hintText,

  });
  final String hintText;
  Function(String)? onChanged;


  @override
  Widget build(BuildContext context) {
    return TextFormField(


      validator: (data) {
        if (data!.isEmpty) {
          return 'field is required';
        }
      },
      onChanged: onChanged,
      decoration: InputDecoration(

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
