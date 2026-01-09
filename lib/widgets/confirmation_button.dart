import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class ConfirmationButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? backgroundColor;
  final Color? textColor;

  const ConfirmationButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: FontWeight.w600,
            color: textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
