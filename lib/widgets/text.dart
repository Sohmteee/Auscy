import 'package:flutter/material.dart';

class AppBoldText extends StatefulWidget {
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
  State<AppBoldText> createState() => _AppBoldTextState();
}

class _AppBoldTextState extends State<AppBoldText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontWeight: widget.fontWeight ?? FontWeight.bold,
        fontFamily: 'Quicksand',
        fontSize: widget.fontSize,
        color: widget.color ?? Theme.of(context).textTheme.bodySmall?.color,
      ),
      textAlign: widget.textAlign,
    );
  }
}

class AppText extends StatefulWidget {
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
  State<AppText> createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontWeight: widget.fontWeight ?? FontWeight.normal,
        fontFamily: 'Quicksand',
        fontSize: widget.fontSize,
        color: widget.color ?? Theme.of(context).textTheme.bodySmall?.color,
      ),
      textAlign: widget.textAlign,
    );
  }
}
