import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/confirmation_button.dart';
import 'package:vans/widgets/app_text_field.dart';
import 'package:vans/widgets/app_logo.dart';
import 'package:vans/providers/navigation_provider.dart';
import 'package:vans/providers/route_provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _departureDateController = TextEditingController();

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _departureDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Logo e Título
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: AppLogo(size: 100, showSubtitle: false),
          ),

          // Card de Busca
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: AppColors.backgroudGray,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                const Text(
                  'Encontre sua passagem!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 24),

                // Campo: Saindo de
                AppTextField(
                  label: 'Saindo de:',
                  hintText: 'Origem da sua viagem',
                  controller: _originController,
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),

                // Campo: Chegando em
                AppTextField(
                  label: 'Chegando em:',
                  hintText: 'Destino da sua viagem',
                  controller: _destinationController,
                  prefixIcon: Icons.location_on,
                ),
                const SizedBox(height: 16),

                // Campo: Dia da ida
                AppTextField(
                  label: 'Dia da ida:',
                  hintText: '04/10/2025',
                  controller: _departureDateController,
                  prefixIcon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      _departureDateController.text =
                          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Botão Buscar
                ConfirmationButton(
                  label: 'Buscar',
                  onPressed: () {
                    // Buscar rotas com os filtros
                    final routeProvider = Provider.of<RouteProvider>(
                      context,
                      listen: false,
                    );
                    routeProvider.searchRoutes(
                      origin: _originController.text.trim(),
                      destination: _destinationController.text.trim(),
                      date: _departureDateController.text.trim(),
                    );

                    // Navegar para resultados
                    final navProvider = Provider.of<NavigationProvider>(
                      context,
                      listen: false,
                    );
                    navProvider.navigateTo(AppScreen.results);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
