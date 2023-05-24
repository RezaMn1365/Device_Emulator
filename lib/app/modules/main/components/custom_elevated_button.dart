import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  bool enabled;
  String buttonText;
  final VoidCallback onPressed;
  CircularButton(
      {required this.enabled,
      required this.buttonText,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
          style: ButtonStyle(
            enableFeedback: true,
            shape: MaterialStateProperty.all(const CircleBorder()),
            padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
            backgroundColor:
                MaterialStateProperty.all(Colors.blue), // <-- Button color
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.redAccent;
              } // <-- Splash color
            }),
          ),
          onPressed: enabled ? onPressed : null,
          child: Text(buttonText)),
    );
  }
}

class RectangelButton extends StatelessWidget {
  bool enabled;
  String buttonText;
  final VoidCallback onPressed;
  RectangelButton(
      {required this.enabled,
      required this.buttonText,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: ElevatedButton(
          style: ButtonStyle(
            enableFeedback: true,
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)))),
            padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
            backgroundColor:
                MaterialStateProperty.all(Colors.blue), // <-- Button color
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black54;
              } // <-- Splash color
            }),
          ),
          onPressed: enabled ? onPressed : null,
          child: Text(buttonText)),
    );
  }
}
