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
                MenuProfileHeader(
                  userName: userProvider.userName,
                  userEmail: userProvider.userEmail,
                  onTap: () {
                    Provider.of<NavigationProvider>(
                      context,
                      listen: false,
                    ).navigateTo(AppScreen.profile);
                  },
                ),
                const SizedBox(height: 24),

                // Opções do Menu
                MenuItem(
                  icon: Icons.person_outline,
                  title: 'Meu Perfil',
                  onTap: () {
                    Provider.of<NavigationProvider>(
                      context,
                      listen: false,
                    ).navigateTo(AppScreen.profile);
                  },
                ),
                MenuItem(icon: Icons.wallet, title: 'Carteira', onTap: () {}),
                MenuItem(
                  icon: Icons.credit_card,
                  title: 'Formas de Pagamento',
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.history,
                  title: 'Histórico de Viagens',
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notificações',
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.help_outline,
                  title: 'Ajuda',
                  onTap: () {},
                ),
                MenuItem(
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
}
