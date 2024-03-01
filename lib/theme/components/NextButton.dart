import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
final VoidCallback onTap;

const NextButton(
      {Key? key, required this.onTap})
      : super(key: key);
@override
Widget build(BuildContext context) {
  return Container(
                height: 40, // Standard Material button height
                width: 40, // Making it a circle
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Button color
                  shape: BoxShape.circle, // Circular shape
                ),
                child: InkWell(
                  onTap: onTap,
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              );
}
}