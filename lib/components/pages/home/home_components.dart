import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget{
  final String text;
  final void Function() onPressed;

  const HomeButton({Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 25.0, color: Colors.black)
        ),
      ),
    );
  }
}
