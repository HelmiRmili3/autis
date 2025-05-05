import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final bool enabled;
  final bool readOnly;
  final IconData? prefixIcon;

  const CustomPasswordField({
    super.key,
    this.validator,
    this.controller,
    required this.labelText,
    required this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: Colors.grey)
            : null,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      validator: widget.validator,
      keyboardType: TextInputType.visiblePassword,
      style: const TextStyle(
        letterSpacing: 0.5, // Makes password dots more distinct
      ),
    );
  }
}
