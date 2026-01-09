import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';

/// Widget de AppBar reutilizável para o aplicativo GoRotas.
///
/// Exibe o logo do app, título e ações opcionais.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Título exibido no header
  final String title;

  /// Se deve mostrar o botão de voltar
  final bool showBackButton;

  /// Callback quando o botão de voltar é pressionado
  final VoidCallback? onBackPressed;

  /// Lista de widgets de ação (lado direito do header)
  final List<Widget>? actions;

  /// Cor de fundo do header
  final Color backgroundColor;

  /// Se deve mostrar o logo
  final bool showLogo;

  /// Se deve mostrar o botão de notificações (padrão)
  final bool showNotifications;

  /// Callback quando o botão de notificações é pressionado
  final VoidCallback? onNotificationsPressed;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.backgroundColor = AppColors.primaryBlue,
    this.showLogo = true,
    this.showNotifications = true,
    this.onNotificationsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          if (showLogo) ...[_buildLogo(), const SizedBox(width: 12)],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: actions ?? _buildDefaultActions(),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.png',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.directions_bus,
              size: 28,
              color: AppColors.primaryBlue,
            );
          },
        ),
      ),
    );
  }

  List<Widget>? _buildDefaultActions() {
    if (!showNotifications) return null;

    return [
      IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: onNotificationsPressed ?? () {},
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
