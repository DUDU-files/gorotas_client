import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class DriverInfoCard extends StatelessWidget {
  final String driverName;
  final String rating;
  final int trips;
  final VoidCallback? onChatPressed;

  const DriverInfoCard({
    super.key,
    required this.driverName,
    required this.rating,
    required this.trips,
    this.onChatPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Foto do motorista
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primaryGray,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          // Info do motorista
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.starFilled,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$rating · $trips+ viagens',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Botão de chat
          if (onChatPressed != null)
            GestureDetector(
              onTap: onChatPressed,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
