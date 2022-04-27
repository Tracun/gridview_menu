import 'package:flutter/material.dart';

class RaisedChild extends StatelessWidget {
  RaisedChild(this.child, this.shadowColor);
  final Widget child;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey)),
        child: child,
      );
    }
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: shadowColor,
      child: child,
    );
  }
}
