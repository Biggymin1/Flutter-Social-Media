import 'package:flutter/material.dart';

class RaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final Color? splashColor;

  const RaisedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.color,
    this.textColor,
    this.padding,
    this.shape,
    this.splashColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,          // Background color
        onPrimary: textColor,     // Text color
        padding: padding,         // 
      ));
  }
}