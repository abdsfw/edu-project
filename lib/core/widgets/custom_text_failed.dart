import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextStyle labelStyle;
  final String? init;
  final IconData prefixIcon;

  final bool readOnly;

  CustomTextFormField({
    required this.controller,
    required this.labelText,
    required this.labelStyle,
    required this.prefixIcon,
    required this.readOnly,
    this.init
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: controller != null ? null : init ?? "",
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(width: 2, color: Colors.black12),
        ),
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: Icon(prefixIcon),
      ),
    );
  }
}
