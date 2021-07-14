import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String label;
  final Color color;

  ButtonWithIcon({required this.onPressed,required this.icon,required this.label,required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(label,style: TextStyle(fontSize: 18.0),),
         style: ElevatedButton.styleFrom(
           primary: color,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.all(Radius.circular(10.0))
           )
         )

    );
  }
}
