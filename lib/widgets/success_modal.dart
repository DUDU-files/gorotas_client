import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/confirmation_button.dart';

/// Modal de sucesso padronizado para o aplicativo.
class SuccessModal extends StatelessWidget {
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconBackgroundColor;

  const SuccessModal({
    super.key,
    this.title = 'Sucesso!',
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
    this.icon = Icons.check,
    this.iconBackgroundColor = AppColors.green,
  });

  /// Exibe o modal de sucesso.
  static void show(
    BuildContext context, {
    String title = 'Sucesso!',
    required String description,
    required String buttonLabel,
    required VoidCallback onPressed,
    IconData icon = Icons.check,
    Color iconBackgroundColor = AppColors.green,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessModal(
        title: title,
        description: description,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
        icon: icon,
        iconBackgroundColor: iconBackgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: 48),
          ),
          const SizedBox(height: 20),

          // Título
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Descrição
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.primaryGray),
          ),
          const SizedBox(height: 24),

          // Botão
          SizedBox(
            width: double.infinity,
            child: ConfirmationButton(label: buttonLabel, onPressed: onPressed),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
