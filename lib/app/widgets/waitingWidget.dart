import 'package:flutter/material.dart';

class WaitingWidget extends StatelessWidget {
  final double theWidht;
  final double theHeight;
  WaitingWidget(this.theWidht, this.theHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: theWidht,
      height: theHeight,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 5,
      ),
    );
  }
}
