import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/exports.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do perfil
                GestureDetector(
                  onTap: () {
                    Provider.of<NavigationProvider>(
                      context,
                      listen: false,
                    ).navigateTo(AppScreen.profile);
                  },
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
                          child: const Icon(
                            Icons.person,
                            size: 35,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProvider.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userProvider.userEmail,
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
                ),
                const SizedBox(height: 24),

                // Opções do Menu
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Meu Perfil',
                  onTap: () {
                    Provider.of<NavigationProvider>(
                      context,
                      listen: false,
                    ).navigateTo(AppScreen.profile);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.wallet,
                  title: 'Carteira',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.credit_card,
                  title: 'Formas de Pagamento',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'Histórico de Viagens',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notificações',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Ajuda',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Configurações',
                  onTap: () {},
                ),
                const SizedBox(height: 24),

                // Botão de Sair
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await userProvider.logout();
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    icon: const Icon(Icons.logout, color: AppColors.white),
                    label: const Text(
                      'Sair',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: AppColors.black),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.primaryGray,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
