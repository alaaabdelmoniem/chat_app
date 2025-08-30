import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField({super.key, required this.hintText, this.onChanged});
  Function(String)? onChanged;
  final String hintText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isoff = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return 'field is required';
        }
      },
      onChanged: widget.onChanged,
      obscureText: isoff ? true : false,
      decoration: InputDecoration(
        suffixIcon:
            isoff
                ? IconButton(
                  onPressed: () {
                    isoff = false;
                    setState(() {});
                  },
                  icon: Icon(Icons.visibility_off, color: Colors.black),
                )
                : IconButton(
                  onPressed: () {
                    isoff = true;
                    setState(() {});
                  },
                  icon: Icon(Icons.visibility, color: Colors.black),
                ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
        contentPadding: EdgeInsets.all(20),
        hintText: widget.hintText,
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
