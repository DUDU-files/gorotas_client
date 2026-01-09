import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final bool isEditing;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCameraPressed;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    this.isEditing = false,
    this.onEditPressed,
    this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
      decoration: const BoxDecoration(color: AppColors.primaryBlue),
      child: Column(
        children: [
          // Botão editar/salvar
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onEditPressed != null)
                IconButton(
                  onPressed: onEditPressed,
                  icon: Icon(
                    isEditing ? Icons.check : Icons.edit,
                    color: AppColors.white,
                  ),
                ),
            ],
          ),
          // Foto do perfil
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.white,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: AppColors.primaryBlue,
                ),
              ),
              if (isEditing && onCameraPressed != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onCameraPressed,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
