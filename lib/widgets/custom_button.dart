import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
const   CustomButton({super.key,this.onTap, required this.title});
  final String title;
final  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(child: Text(title, style: TextStyle(fontSize: 22))),
      ),
    );
  }
}
