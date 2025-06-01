import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? label;
  final int maxLines;
  const CustomTextfield({
    super.key,
    required this.controller,
    this.label,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType:  keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: maxLines,
    );
  }
}
