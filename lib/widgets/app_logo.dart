import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';

/// Widget de logo padronizado para o aplicativo.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showTitle;
  final bool showSubtitle;
  final String? subtitle;

  const AppLogo({
    super.key,
    this.size = 90,
    this.showTitle = true,
    this.showSubtitle = true,
    this.subtitle = 'Acesso para Clientes',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.directions_bus,
                  size: size * 0.6,
                  color: AppColors.primaryBlue,
                );
              },
            ),
          ),
        ),
        if (showTitle) ...[
          const SizedBox(height: 16),
          const Text(
            'GoRotas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
        if (showSubtitle && subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 12, color: AppColors.white),
          ),
        ],
      ],
    );
  }
}
