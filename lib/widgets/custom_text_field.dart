import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:ecom_modwir/constants.dart';

class CustomTextField extends StatelessWidget {
  final String? label;

  final String? hint;

  final String? initialValue;

  final TextEditingController? controller;

  final Function(String)? onChanged;

  final String? Function(String?)? validator;

  final bool obscureText;

  final TextInputType? keyboardType;

  final List<TextInputFormatter>? inputFormatters;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final int? maxLines;

  final bool enabled;

  final bool required;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(color: errorColor),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          onChanged: onChanged,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: errorColor),
            ),
            filled: true,
            fillColor: enabled
                ? (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[50])
                : Colors.grey[200],
          ),
        ),
      ],
    );
  }
}
