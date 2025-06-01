import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? label;
  final String? Function(String?) validator;
  final bool obsecure;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.validator,
    this.label,
    this.obsecure = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obsecure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.label,
        suffixIcon: widget.obsecure
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}
