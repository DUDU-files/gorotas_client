import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class ReceiptHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ReceiptHeader({
    super.key,
    this.title = 'GoRotas',
    this.subtitle = 'Comprovante de Passagem',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.directions_bus,
                    size: 40,
                    color: AppColors.primaryBlue,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
