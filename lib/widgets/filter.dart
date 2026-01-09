import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/providers/route_provider.dart';

class FiltersModal extends StatefulWidget {
  const FiltersModal({super.key});

  @override
  State<FiltersModal> createState() => _FiltersModalState();
}

class _FiltersModalState extends State<FiltersModal> {
  List<String> selectedTimes = [];
  final List<Map<String, String>> availableTimes = [
    {'label': '06:00 - 11:59', 'value': '06:00 - 11:59'},
    {'label': '12:00 - 17:59', 'value': '12:00 - 17:59'},
    {'label': '18:00 - 23:59', 'value': '18:00 - 23:59'},
    {'label': '00:00 - 05:59', 'value': '00:00 - 05:59'},
  ];

  double minPrice = 0;
  double maxPrice = 1000;

  bool vanSelected = false;
  bool lotacaoSelected = false;

  @override
  void initState() {
    super.initState();
    // Carregar filtros atuais do provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RouteProvider>();
      setState(() {
        selectedTimes = List.from(provider.selectedTimeRanges);
        minPrice = provider.minPrice;
        maxPrice = provider.maxPrice;
        vanSelected = provider.selectedVehicleTypes.contains('Van');
        lotacaoSelected = provider.selectedVehicleTypes.contains('Lotação');
      });
    });
  }

  void _applyFilters() {
    final provider = context.read<RouteProvider>();

    List<String> vehicleTypes = [];
    if (vanSelected) vehicleTypes.add('Van');
    if (lotacaoSelected) vehicleTypes.add('Lotação');

    provider.applyFilters(
      timeRanges: selectedTimes,
      minPrice: minPrice,
      maxPrice: maxPrice,
      vehicleTypes: vehicleTypes,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filtros aplicados!'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      selectedTimes = [];
      minPrice = 0;
      maxPrice = 1000;
      vanSelected = false;
      lotacaoSelected = false;
    });

    // Também limpar no provider
    final provider = context.read<RouteProvider>();
    provider.applyFilters(
      timeRanges: [],
      minPrice: 0,
      maxPrice: 1000,
      vehicleTypes: [],
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header com logo e título
            Container(
              color: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
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
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.tune, color: AppColors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Conteúdo dos filtros
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seção Horário
                  Text(
                    'Horário',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.5,
                    children: availableTimes.map((time) {
                      bool isSelected = selectedTimes.contains(time['value']);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedTimes.remove(time['value']);
                            } else {
                              selectedTimes.add(time['value']!);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryBlue
                                : Colors.transparent,
                            border: Border.all(
                              color: AppColors.primaryBlue,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            time['label']!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Divider(color: AppColors.backgroudGray, height: 1),
                  const SizedBox(height: 24),

                  // Seção Preço
                  Text(
                    'Preço',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Min Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.backgroudGray,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'R\$ ${minPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      // Max Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.backgroudGray,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'R\$ ${maxPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    activeColor: AppColors.primaryBlue,
                    inactiveColor: AppColors.backgroudGray,
                    labels: RangeLabels(
                      'R\$ ${minPrice.toStringAsFixed(0)}',
                      'R\$ ${maxPrice.toStringAsFixed(0)}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        minPrice = values.start;
                        maxPrice = values.end;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Divider(color: AppColors.backgroudGray, height: 1),
                  const SizedBox(height: 24),

                  // Seção Tipo de Veículo
                  Text(
                    'Tipo de Veículo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Van Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: vanSelected,
                        onChanged: (value) {
                          setState(() {
                            vanSelected = value ?? false;
                          });
                        },
                        activeColor: AppColors.primaryBlue,
                      ),
                      const Text(
                        'Van',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  // Lotação Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: lotacaoSelected,
                        onChanged: (value) {
                          setState(() {
                            lotacaoSelected = value ?? false;
                          });
                        },
                        activeColor: AppColors.primaryBlue,
                      ),
                      const Text(
                        'Lotação',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botões de ação
                  Row(
                    children: [
                      // Descartar Filtros
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _clearFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Limpar Filtros',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Aplicar Filtros
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Aplicar Filtros',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
