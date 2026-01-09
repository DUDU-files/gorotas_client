import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vans/colors/app_colors.dart';

/// Widget de campo de texto padronizado para o aplicativo GoRotas.
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final Color? fillColor;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.isPassword = false,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.fillColor,
    this.maxLines = 1,
    this.inputFormatters,
    this.textInputAction,
    this.onSubmitted,
  });

  static final _borderRadius = BorderRadius.circular(8);

  static final _defaultDecoration = InputDecoration(
    filled: true,
    fillColor: AppColors.white,
    hintStyle: TextStyle(color: AppColors.lightGray, fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGray,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          enabled: enabled,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          onFieldSubmitted: onSubmitted,
          style: const TextStyle(fontSize: 14, color: AppColors.black),
          decoration: _defaultDecoration.copyWith(
            hintText: hintText,
            fillColor: fillColor,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.lightGray, size: 20)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(
                      suffixIcon,
                      color: AppColors.lightGray,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
