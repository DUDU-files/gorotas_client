import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';

/// Card padrão reutilizável para toda a aplicação
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: child,
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: card) : card;
  }
}

/// Widget para exibir origem e destino
class LocationRow extends StatelessWidget {
  final String origin;
  final String destination;
  final bool showIcons;

  const LocationRow({
    super.key,
    required this.origin,
    required this.destination,
    this.showIcons = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showIcons) ...[
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              origin,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primaryGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (showIcons) ...[
              const Icon(Icons.location_on, size: 16, color: AppColors.green),
              const SizedBox(width: 8),
            ],
            Text(
              destination,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primaryGray,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget para informações do motorista
class DriverInfo extends StatelessWidget {
  final String name;
  final String rating;
  final int trips;
  final VoidCallback? onChatTap;

  const DriverInfo({
    super.key,
    required this.name,
    this.rating = '0.0',
    this.trips = 0,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.person, color: AppColors.primaryGray),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: AppColors.starFilled),
                  const SizedBox(width: 4),
                  Text(
                    '$rating · $trips+ viagens',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (onChatTap != null)
          GestureDetector(
            onTap: onChatTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }
}

/// Botão de ação principal
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}

/// Chip/Tag reutilizável
class InfoTag extends StatelessWidget {
  final String label;

  const InfoTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: AppColors.primaryBlue),
      ),
    );
  }
}

/// Estado vazio padrão
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onRetry;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.primaryGray),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(color: AppColors.primaryGray, fontSize: 16),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(color: AppColors.lightGray, fontSize: 14),
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading padrão
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryOrange),
    );
  }
}
