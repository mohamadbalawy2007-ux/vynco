import 'package:flutter/material.dart';
import 'package:project_1/My_Tools/colors.dart';

class MyButton extends StatelessWidget {
  final String txt;
  final VoidCallback onClick;
  const MyButton({Key? key, required this.txt, required this.onClick})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 45),
          backgroundColor: MyButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onClick,
        
        child: Text(txt),
      ),
    );
  }
}
