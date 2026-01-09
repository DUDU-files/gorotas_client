import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/confirmation_button.dart';
import 'package:vans/providers/navigation_provider.dart';
import 'package:vans/providers/route_provider.dart';

class SearchContent extends StatefulWidget {
  const SearchContent({super.key});

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.directions_bus,
                          size: 70,
                          color: AppColors.primaryBlue,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'GoRotas',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
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
                Text(
                  'Saindo de:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGray,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _originController,
                  decoration: InputDecoration(
                    hintText: 'Origem da sua viagem',
                    hintStyle: TextStyle(
                      color: AppColors.lightGray,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.lightGray,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo: Chegando em
                Text(
                  'Chegando em:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGray,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    hintText: 'Destino da sua viagem',
                    hintStyle: TextStyle(
                      color: AppColors.lightGray,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: AppColors.lightGray,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo: Dia da ida
                Text(
                  'Dia da ida:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGray,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _departureDateController,
                  decoration: InputDecoration(
                    hintText: '04/10/2025',
                    hintStyle: TextStyle(
                      color: AppColors.lightGray,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.lightGray,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
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
