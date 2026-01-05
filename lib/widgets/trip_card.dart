import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';

class TripCard extends StatelessWidget {
  final String type;
  final String date;
  final String origin;
  final String destination;
  final double rating;
  final VoidCallback onDownload;
  final VoidCallback? onRating;

  const TripCard({
    super.key,
    required this.type,
    required this.date,
    required this.origin,
    required this.destination,
    required this.rating,
    required this.onDownload,
    this.onRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryBlue,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tipo de veículo e ícone de bilhete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const Icon(
                Icons.receipt,
                color: AppColors.primaryGray,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Data
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Origem
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 14,
                color: AppColors.primaryOrange,
              ),
              const SizedBox(width: 8),
              Text(
                origin,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Destino
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 14,
                color: AppColors.green,
              ),
              const SizedBox(width: 8),
              Text(
                destination,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Avaliação e botão de download
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onRating,
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.starFilled,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Avaliação',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryBlue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Botão de download
              ElevatedButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.download, size: 14),
                label: const Text('Download PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
