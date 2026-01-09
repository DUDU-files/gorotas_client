import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class MenuProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onTap;

  const MenuProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroudGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.person, size: 35, color: AppColors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: AppColors.primaryGray),
          ],
        ),
      ),
    );
  }
}
