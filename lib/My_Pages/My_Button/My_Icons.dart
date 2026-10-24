
import 'package:flutter/material.dart';

class MyIcons extends StatelessWidget {
  final IconData icon;
  final String txt;
  final VoidCallback onClick;
  const MyIcons({Key? key, required this.icon, required this.txt , required this.onClick})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onClick,
          child: Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(211, 53, 53, 53),
              boxShadow: [BoxShadow(blurRadius: 1)],
              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(icon, size: 80),
          ),
        ),

        Text(txt , style: TextStyle(fontSize: 20),),

        
      ],
    );
  }
}
