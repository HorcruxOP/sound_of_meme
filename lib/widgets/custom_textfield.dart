import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.controller,
      this.validator,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.enabled = true});
  final String hintText, labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          enabled: enabled,
          maxLines: maxLines,
          controller: controller,
          cursorColor: Colors.white,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            errorStyle: const TextStyle(color: Colors.red),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            alignLabelWithHint: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          validator: validator,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
