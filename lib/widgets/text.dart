import 'package:flutter/material.dart';

class AppBoldText extends StatelessWidget {
  const AppBoldText(
    this.text, {
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    super.key,
  });

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.bold,
        fontFamily: 'Quicksand',
        fontSize: fontSize,
      ),
      textAlign: textAlign,
    );
  }
}

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    super.key,
  });

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.normal,
        fontFamily: 'Quicksand',
        fontSize: fontSize,
      ),
      textAlign: textAlign,
    );
  }
}
