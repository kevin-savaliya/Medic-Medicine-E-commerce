import 'package:flutter/material.dart';

class TextWidget extends Text {
  final String text;
  final TextStyle? style;
  final TextOverflow? textOverflow;
  final TextAlign textAlign;
  final int? maxLine;
  final TextDecoration? decoration;

  const TextWidget(
    this.text, {
    super.key,
    this.style,
    this.textOverflow,
    this.textAlign = TextAlign.center,
    this.maxLine,
    this.decoration,
  }) : super('');

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? Theme.of(context).textTheme.bodyMedium,
      maxLines: maxLine,
      textAlign: textAlign,
    );
  }
}
