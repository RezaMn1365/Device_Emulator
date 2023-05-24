import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'custom_elevated_button.dart';

class LED extends StatefulWidget {
  final VoidCallback onPressed;
  bool buttomEnable;
  bool locked;
  bool onOff;
  bool blinking;
  Color userColor;
  String buttomText;
  LED(
      {required this.buttomEnable,
      required this.locked,
      required this.onPressed,
      required this.onOff,
      required this.blinking,
      required this.buttomText,
      required this.userColor,
      super.key});
  @override
  _LEDState createState() => _LEDState();
}

class _LEDState extends State<LED> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.blinking
        ? _animationController.repeat(reverse: true)
        : widget.onOff
            ? _animationController.animateTo(1)
            : _animationController.animateTo(0);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: widget.onOff
                      ? FadeTransition(
                          opacity: _animationController,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: widget.userColor,
                              shape: BoxShape.circle,
                            ),
                            child: null,
                          ),
                        )
                      : Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: null,
                        ),
                ),
              ),
              // Text(widget.buttomText),

              Expanded(
                child: widget.locked
                    ? const Icon(
                        Icons.lock,
                        size: 35,
                      )
                    : const Icon(
                        Icons.lock_open,
                        size: 35,
                      ),
              ),
            ],
          ),
          RectangelButton(
              enabled: widget.buttomEnable,
              buttonText: widget.buttomText,
              onPressed: widget.onPressed),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
