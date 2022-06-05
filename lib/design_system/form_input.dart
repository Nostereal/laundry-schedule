import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    Key? key,
    this.initialValue,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = false,
  }) : super(key: key);

  final String? initialValue;
  final String? hint;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        initialValue: initialValue,
        validator: validator,
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
      ),
    );
  }
}
