import 'package:flutter/material.dart';

class CustomFormTextFiled extends StatelessWidget {
  /// A custom text field widget with a label and rounded border.
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String lableText;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final IconData? trailingIcon;
  final IconData? prefixIcon;
  const CustomFormTextFiled({
    super.key,
    this.validator,
    this.controller,
    required this.lableText,
    required this.hintText,
    required this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.trailingIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: lableText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.grey,
              )
            : null,
        suffixIcon: trailingIcon != null
            ? Icon(
                trailingIcon,
                color: Colors.grey,
              )
            : null,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      validator: validator,
    );
  }
}
